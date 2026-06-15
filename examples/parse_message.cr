require "../src/crystal_iso8583"
require "option_parser"

# Parse ISO 8583 v1993 authorization request (1100) messages from binary files
# and write each result as JSON.
#
# ISO 8583 messages transported over TCP are typically prefixed with a 4-byte
# ASCII decimal network length indicator. The header is stripped before parsing.
NETWORK_HEADER_SIZE = 4

codec = CrystalIso8583::Shared::Codec::ASCII.new
input_glob = "data/in/*.in"
output_dir = "data/out"
header_size = NETWORK_HEADER_SIZE

OptionParser.parse do |parser|
  parser.banner = "Usage: crystal run examples/parse_message.cr -- [options]"

  parser.on("-i PATTERN", "--input PATTERN", "Input file glob (default: data/in/*.in)") { |p| input_glob = p }
  parser.on("-o DIR", "--output-dir DIR", "Output directory for JSON files (default: data/out)") { |d| output_dir = d }
  parser.on("--header-size N", "Header bytes to strip before parsing (default: 4)") { |n| header_size = n.to_i }
  parser.on("-h", "--help", "Show this help") { puts parser; exit 0 }

  parser.invalid_option do |flag|
    STDERR.puts "Unknown flag: #{flag}"
    STDERR.puts parser
    exit 1
  end
end

Dir[input_glob].each do |input_file|
  puts "Processing #{input_file}..."
  raw = File.open(input_file, "rb") { |f| f.getb_to_end }
  bytes = raw[header_size..]
  msg = CrystalIso8583::V1993::Msg1100.parse(bytes, codec)
  output_file = File.join(output_dir, File.basename(input_file).sub(/\.in$/, ".json"))
  File.write(output_file, msg.to_json)
rescue e
  STDERR.puts "Error processing #{input_file}: #{e.message}"
end
