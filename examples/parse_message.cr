require "../src/crystal_iso8583"

file_path = ARGV[0]? || File.join(__DIR__, "data", "msg_1100.bin")
raw = File.open(file_path, "rb") { |f| f.getb_to_end }

# ISO 8583 messages transported over TCP are typically prefixed with a 4-byte
# network length indicator. Strip it before handing the payload to the parser.
NETWORK_HEADER_SIZE = 4
bytes = raw[NETWORK_HEADER_SIZE..]

codec = CrystalIso8583::Shared::Codec::ASCII.new
msg = CrystalIso8583::V1993::Msg1100.parse(bytes, codec)
puts msg.to_json
