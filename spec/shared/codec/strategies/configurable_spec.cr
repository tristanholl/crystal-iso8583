require "../../../spec_helper"

private alias Configurable = CrystalIso8583::Shared::Codec::Configurable
private alias MtiEncoding = CrystalIso8583::Shared::Codec::MtiEncoding
private alias NumericEncoding = CrystalIso8583::Shared::Codec::NumericEncoding
private alias TextEncoding = CrystalIso8583::Shared::Codec::TextEncoding
private alias LengthEncoding = CrystalIso8583::Shared::Codec::LengthEncoding
private alias DataType = CrystalIso8583::Shared::DataType

describe Configurable do
  describe "mti" do
    it "round-trips ASCII MTI" do
      codec = Configurable.new(mti_encoding: MtiEncoding::ASCII)
      mti = CrystalIso8583::Shared::MTI.parse("0100")
      codec.decode_mti(codec.encode_mti(mti)).to_s.should eq "0100"
    end

    it "round-trips BCD MTI" do
      codec = Configurable.new(mti_encoding: MtiEncoding::BCD)
      mti = CrystalIso8583::Shared::MTI.parse("0100")
      encoded = codec.encode_mti(mti)
      encoded.size.should eq 2
      codec.decode_mti(encoded).to_s.should eq "0100"
    end

    it "round-trips EBCDIC MTI" do
      codec = Configurable.new(mti_encoding: MtiEncoding::EBCDIC)
      mti = CrystalIso8583::Shared::MTI.parse("0100")
      codec.decode_mti(codec.encode_mti(mti)).to_s.should eq "0100"
    end
  end

  describe "length prefixes" do
    it "round-trips ASCII length prefixes" do
      codec = Configurable.new(length_encoding: LengthEncoding::ASCII)
      codec.decode_length(codec.encode_length(12, 2), 2).should eq 12
    end

    it "round-trips BCD length prefixes" do
      codec = Configurable.new(length_encoding: LengthEncoding::BCD)
      codec.decode_length(codec.encode_length(123, 3), 3).should eq 123
    end

    it "round-trips EBCDIC length prefixes" do
      codec = Configurable.new(length_encoding: LengthEncoding::EBCDIC)
      codec.decode_length(codec.encode_length(12, 2), 2).should eq 12
    end

    it "round-trips Binary length prefixes as a single byte by default, for LLVAR and LLLVAR alike" do
      codec = Configurable.new(length_encoding: LengthEncoding::Binary)
      codec.length_byte_size(2).should eq 1
      codec.length_byte_size(3).should eq 1
      encoded = codec.encode_length(9, 2)
      encoded.should eq Bytes[0x09]
      codec.decode_length(encoded, 2).should eq 9
      codec.decode_length(codec.encode_length(34, 3), 3).should eq 34
    end

    it "supports a wider binary_length_byte_size for fields needing it" do
      codec = Configurable.new(length_encoding: LengthEncoding::Binary, binary_length_byte_size: 2)
      codec.length_byte_size(3).should eq 2
      encoded = codec.encode_length(260, 3)
      codec.decode_length(encoded, 3).should eq 260
    end
  end

  describe "numeric field data" do
    it "round-trips ASCII numeric fields" do
      codec = Configurable.new(numeric_encoding: NumericEncoding::ASCII)
      encoded = codec.encode_field("1234", DataType::N)
      codec.decode_field(encoded, DataType::N, 4).should eq "1234"
    end

    it "round-trips BCD numeric fields" do
      codec = Configurable.new(numeric_encoding: NumericEncoding::BCD)
      encoded = codec.encode_field("1234", DataType::N)
      codec.field_byte_size(4, DataType::N).should eq 2
      codec.decode_field(encoded, DataType::N, 4).should eq "1234"
    end

    it "round-trips EBCDIC numeric fields" do
      codec = Configurable.new(numeric_encoding: NumericEncoding::EBCDIC)
      encoded = codec.encode_field("1234", DataType::N)
      codec.decode_field(encoded, DataType::N, 4).should eq "1234"
    end
  end

  describe "text field data" do
    it "round-trips ASCII text fields" do
      codec = Configurable.new(text_encoding: TextEncoding::ASCII)
      encoded = codec.encode_field("HELLO", DataType::ANS)
      codec.decode_field(encoded, DataType::ANS, 5).should eq "HELLO"
    end

    it "round-trips EBCDIC text fields" do
      codec = Configurable.new(text_encoding: TextEncoding::EBCDIC)
      encoded = codec.encode_field("HELLO", DataType::ANS)
      codec.decode_field(encoded, DataType::ANS, 5).should eq "HELLO"
    end
  end

  describe "track 2 (Z) field data" do
    it "BCD-packs track 2 data, including the '=' separator, when numeric_encoding is BCD" do
      codec = Configurable.new(numeric_encoding: NumericEncoding::BCD)
      track2 = "1234567890123456=2512101123456789"
      encoded = codec.encode_field(track2, DataType::Z)
      codec.field_byte_size(track2.size, DataType::Z).should eq 17
      encoded.size.should eq 17
      codec.decode_field(encoded, DataType::Z, track2.size).should eq track2
    end

    it "falls back to text_encoding for track 2 data when numeric_encoding isn't BCD" do
      codec = Configurable.new(numeric_encoding: NumericEncoding::ASCII, text_encoding: TextEncoding::EBCDIC)
      track2 = "1234=5678"
      encoded = codec.encode_field(track2, DataType::Z)
      codec.decode_field(encoded, DataType::Z, track2.size).should eq track2
    end
  end

  it "always treats binary field data as raw bytes regardless of other settings" do
    codec = Configurable.new(numeric_encoding: NumericEncoding::BCD, text_encoding: TextEncoding::EBCDIC)
    encoded = codec.encode_field("aabb", DataType::B)
    encoded.should eq Bytes[0xaa, 0xbb]
    codec.decode_field(encoded, DataType::B, 2).should eq "aabb"
  end
end
