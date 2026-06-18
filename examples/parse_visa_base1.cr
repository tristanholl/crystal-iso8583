require "../src/crystal_iso8583"

# Parses a real Visa BASE I 0100 message. Verified against an authoritative
# field-by-field reference decode of a live sample:
#
# - A 22-byte proprietary network header precedes the ISO 8583 payload
#   (not the 4-byte ASCII TCP length prefix assumed elsewhere in this repo).
# - MTI is BCD-packed, variable-length prefixes are a single raw binary
#   byte regardless of LLVAR vs LLLVAR, numeric field data is BCD-packed,
#   and alphanumeric/text field data is EBCDIC.
# - This deployment deviates from the generic ISO 8583:1987 dictionary in
#   two ways: fields 19 and 22 are 4 digits wide (not 3), and the
#   "Additional Data" fields (54, 56, 60, 62, 63, 104, 123) carry raw
#   binary/TLV sub-structures rather than text, so they're typed as binary
#   (rendered as hex) instead of ANS.
#
# Usage: crystal run examples/parse_visa_base1.cr -- path/to/message.in

path = ARGV[0]? || abort "Usage: crystal run examples/parse_visa_base1.cr -- <file>"

codec = CrystalIso8583::Shared::Codec::Configurable.new(
  mti_encoding: CrystalIso8583::Shared::Codec::MtiEncoding::BCD,
  length_encoding: CrystalIso8583::Shared::Codec::LengthEncoding::Binary,
  numeric_encoding: CrystalIso8583::Shared::Codec::NumericEncoding::BCD,
  text_encoding: CrystalIso8583::Shared::Codec::TextEncoding::EBCDIC,
)

dictionary = CrystalIso8583::V1987::DataDictionary.fields.dup

{19 => 4, 22 => 4}.each do |id, max_length|
  d = dictionary[id]
  dictionary[id] = CrystalIso8583::Shared::FieldDescriptor.new(id, d.encoding, max_length, d.data_type, d.label)
end

{54, 56, 60, 62, 63, 104, 123}.each do |id|
  d = dictionary[id]
  dictionary[id] = CrystalIso8583::Shared::FieldDescriptor.new(id, d.encoding, d.max_length, CrystalIso8583::Shared::DataType::B, d.label)
end

header = CrystalIso8583::Shared::Header::FixedLength.new(22)

raw = File.open(path, "rb") { |f| f.getb_to_end }
bytes = header.strip(raw)

parser = CrystalIso8583::Shared::Parser.new(dictionary, codec, debug: true)
message = parser.parse(bytes)

puts message.to_json(dictionary)
