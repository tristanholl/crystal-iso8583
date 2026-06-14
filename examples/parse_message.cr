require "../src/crystal_iso8583"

# ISO 8583 messages transported over TCP are typically prefixed with a 4-byte
# network length indicator. Strip it before handing the payload to the parser.
NETWORK_HEADER_SIZE = 4
codec = CrystalIso8583::Shared::Codec::ASCII.new

file_path = ARGV[0]? || File.join(__DIR__, "data", "msg_1100.bin")
# raw = File.open(file_path, "rb") { |f| f.getb_to_end }

Dir["data/in/*.in"].each do |input_file|
  puts "Processing #{input_file}..."
  output_file = input_file.sub(/\.in$/, ".json")
  raw = File.open(input_file, "rb") { |f| f.getb_to_end }

  bytes = raw[NETWORK_HEADER_SIZE..]
  msg = CrystalIso8583::V1993::Msg1100.parse(bytes, codec)

  output_file = ["data", "out", File.basename(input_file).sub(/\.in$/, ".json")].join(File::SEPARATOR)
  File.write(output_file, msg.to_json)
rescue e
  puts "Error processing #{input_file}: #{e.message}"
end
