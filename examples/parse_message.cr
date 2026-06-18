require "../src/crystal_iso8583"
require "option_parser"
require "./scheme"

# Parse ISO 8583 authorization request messages from binary files and write
# each result as JSON. Supports both the 1987 (Msg0100) and 1993 (Msg1100)
# message versions.
#
# ISO 8583 messages transported over TCP are typically prefixed with a 4-byte
# ASCII decimal network length indicator. The header is stripped before parsing.
NETWORK_HEADER_SIZE = 4

# --scheme visa (or --codec configurable) builds a Codec::Configurable with
# BCD MTI/numeric fields, a single raw binary length-prefix byte, and EBCDIC
# text fields, plus the 22-byte header — the mix used by real-world Visa
# BASE I deployments. Run with `--scheme visa -i path/to/visa.in` to parse
# such a message directly; no separate example is needed.

version = "1993"
codec_name = nil
input_glob = "data/in/*.in"
output_dir = "data/out"
header_size = NETWORK_HEADER_SIZE
debug = false
scheme = nil
version_explicit = false
codec_explicit = false
header_size_explicit = false

OptionParser.parse do |parser|
  parser.banner = "Usage: crystal run examples/parse_message.cr -- [options]"

  parser.on("--version VERSION", "Message version: 1987 or 1993 (default: 1993)") { |v| version = v; version_explicit = true }
  parser.on("--codec CODEC", "Codec: ascii, bcd, ebcdic, or configurable (default: ascii for 1993, ebcdic for 1987)") { |c| codec_name = c; codec_explicit = true }
  parser.on("-i PATTERN", "--input PATTERN", "Input file glob (default: data/in/*.in)") { |p| input_glob = p }
  parser.on("-o DIR", "--output-dir DIR", "Output directory for JSON files (default: data/out)") { |d| output_dir = d }
  parser.on("--header-size N", "Header bytes to strip before parsing (default: 4)") { |n| header_size = n.to_i; header_size_explicit = true }
  parser.on("--scheme SCHEME", "Message scheme preset: visa (forces version 1987, configurable codec, 22-byte header)") { |s| scheme = s }
  parser.on("--debug", "Trace MTI/bitmap/field offsets and decoded values to STDOUT") { debug = true }
  parser.on("-h", "--help", "Show this help") { puts parser; exit 0 }

  parser.invalid_option do |flag|
    STDERR.puts "Unknown flag: #{flag}"
    STDERR.puts parser
    exit 1
  end
end

resolved = Scheme.resolve(scheme, version, codec_name, header_size,
  explicit_version: version_explicit, explicit_codec: codec_explicit, explicit_header_size: header_size_explicit)
version = resolved.version
codec_name = resolved.codec_name
codec = resolved.codec
header_size = resolved.header_size.not_nil!

unless ["1987", "1993"].includes?(version)
  STDERR.puts "Unknown version: #{version} (expected 1987 or 1993)"
  exit 1
end

header_strategy = CrystalIso8583::Shared::Header::FixedLength.new(header_size)

Dir[input_glob].each do |input_file|
  puts "Processing #{input_file}..."
  raw = File.open(input_file, "rb") { |f| f.getb_to_end }
  bytes = header_strategy.strip(raw)
  msg = if version == "1987"
          CrystalIso8583::V1987::Msg0100.parse(bytes, codec, debug)
        else
          CrystalIso8583::V1993::Msg1100.parse(bytes, codec, debug)
        end
  output_file = File.join(output_dir, File.basename(input_file).sub(/\.in$/, ".json"))
  File.write(output_file, msg.to_json)
rescue e
  STDERR.puts "Error processing #{input_file}: #{e.message}"
end
