require "../src/crystal_iso8583"

# Read raw ISO 8583 bytes from file.
file_path = ARGV[0]? || File.join(__DIR__, "data", "msg_1100.bin")
bytes = File.open(file_path, "rb") { |f| f.getb_to_end }

codec = CrystalIso8583::Shared::Codec::ASCII.new
msg = CrystalIso8583::V1993::Msg1100.parse(bytes, codec)
puts msg.to_json
