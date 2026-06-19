require "../src/crystal_iso8583"
require "option_parser"
require "json"
require "./scheme"
require "./message_registry"

# Build an ISO 8583 message from a JSON input file and write the framed
# payload to a file. The input JSON supplies the MTI and field values; the
# MTI determines both the message class (e.g. "0100" -> Msg0100, "1100" ->
# Msg1100) and the implied version (first digit "0" -> 1987, "1" -> 1993),
# so no separate --version flag is needed.
#
# Input JSON shape (same shape TypedMessage#to_json emits, so parser output
# can be fed straight back into the builder):
#   { "mti": "1100", "fields": { "2": "...", "3": { "value": "...", "label": "..." } } }
#
# ISO 8583 messages transported over TCP are typically prefixed with a 4-byte
# ASCII decimal network length indicator (e.g. "0306" for a 306-byte message).
# This example writes the full framed message by default.
NETWORK_HEADER_SIZE = 4

codec_name = nil
output = nil
add_header = true
scheme = nil
codec_explicit = false

OptionParser.parse do |parser|
  parser.banner = "Usage: crystal run examples/build_message.cr -- <input.json> [options]"

  parser.on("--codec CODEC", "Codec: ascii, bcd, ebcdic, or configurable (default: ascii for 1993-derived MTIs, ebcdic for 1987-derived MTIs)") { |c| codec_name = c; codec_explicit = true }
  parser.on("-o FILE", "--output FILE", "Output file (default: data/out/msg_<mti>_built.bin)") { |f| output = f }
  parser.on("--no-header", "Omit the network header (4-byte ASCII length prefix, or the 22-byte Visa header for --scheme visa)") { add_header = false }
  parser.on("--scheme SCHEME", "Message scheme preset: visa (forces configurable codec, 22-byte header)") { |s| scheme = s }
  parser.on("-h", "--help", "Show this help") { puts parser; exit 0 }

  parser.invalid_option do |flag|
    STDERR.puts "Unknown flag: #{flag}"
    STDERR.puts parser
    exit 1
  end
end

input_path = ARGV[0]?
unless input_path
  STDERR.puts "Missing required <input.json> argument"
  STDERR.puts "Usage: crystal run examples/build_message.cr -- <input.json> [options]"
  exit 1
end

input_json = JSON.parse(File.read(input_path))
mti = input_json["mti"].as_s
version = MessageRegistry.version_for_mti(mti)

resolved = Scheme.resolve(scheme, version, codec_name, explicit_version: false, explicit_codec: codec_explicit)
codec_name = resolved.codec_name
codec = resolved.codec

msg = MessageRegistry.for_mti(mti)
input_json["fields"].as_h.each do |field_id, field_value|
  value = field_value.as_h? ? field_value.as_h["value"].as_s : field_value.as_s
  msg[field_id.to_i] = value
end

mti_string = msg.mti_string
iso_bytes = msg.build(codec)
json_output = msg.to_json

output_path = (output || "data/out/msg_#{mti_string}_built.bin").not_nil!

payload = if !add_header
            iso_bytes
          elsif scheme == "visa"
            Bytes.new(Scheme::VISA_HEADER_SIZE) + iso_bytes
          else
            CrystalIso8583::Shared::Header::AsciiLengthPrefix.new(NETWORK_HEADER_SIZE).wrap(iso_bytes)
          end

Dir.mkdir_p(File.dirname(output_path))
File.open(output_path, "wb") { |f| f.write(payload) }

header_note = if !add_header
                "no network header"
              elsif scheme == "visa"
                "with #{Scheme::VISA_HEADER_SIZE}-byte Visa network header"
              else
                "with #{NETWORK_HEADER_SIZE}-byte network header"
              end
puts "Version     : #{version} (#{mti_string})"
puts "Codec       : #{codec_name}"
puts "ISO message : #{iso_bytes.size} bytes"
puts "Written     : #{payload.size} bytes (#{header_note}) → #{output_path}"
puts json_output
