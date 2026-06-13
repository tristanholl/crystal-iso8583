require "../src/crystal_iso8583"

# Read raw ISO 8583 bytes from file.
file_path = ARGV[0]? || File.join(__DIR__, "data", "msg_1100.bin")
bytes = File.open(file_path, "rb") { |f| f.getb_to_end }

codec = CrystalIso8583::Shared::Codec::ASCII.new

begin
  msg = CrystalIso8583::V1993::Msg1100.parse(bytes, codec)
  puts msg.to_json
rescue NotImplementedError
  # Parser codec is not yet implemented. The example below demonstrates
  # the same to_json output using a manually constructed typed message.
  msg = CrystalIso8583::V1993::Msg1100.new
  msg.iso002 = "4111111111111111"
  msg.iso003 = "000000"
  msg.iso004 = "000000010000"
  msg.iso007 = "0613120000"
  msg.iso011 = "123456"
  msg.iso049 = "840"
  puts msg.to_json
end
