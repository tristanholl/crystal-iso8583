require "../../spec_helper"

private alias Configurable = CrystalIso8583::Shared::Codec::Configurable
private alias SubEncoding = CrystalIso8583::Shared::SubEncoding
private alias DataType = CrystalIso8583::Shared::DataType

describe Configurable do
  describe "mti" do
    it "round-trips ASCII MTI" do
      codec = Configurable.new(mti_encoding: SubEncoding::ASCII)
      mti = CrystalIso8583::Shared::MTI.parse("0100")
      codec.decode_mti(codec.encode_mti(mti)).to_s.should eq "0100"
    end

    it "round-trips BCD MTI" do
      codec = Configurable.new(mti_encoding: SubEncoding::BCD)
      mti = CrystalIso8583::Shared::MTI.parse("0100")
      encoded = codec.encode_mti(mti)
      encoded.size.should eq 2
      codec.decode_mti(encoded).to_s.should eq "0100"
    end

    it "round-trips EBCDIC MTI" do
      codec = Configurable.new(mti_encoding: SubEncoding::EBCDIC)
      mti = CrystalIso8583::Shared::MTI.parse("0100")
      codec.decode_mti(codec.encode_mti(mti)).to_s.should eq "0100"
    end
  end

  describe "length prefixes" do
    it "round-trips ASCII length prefixes" do
      codec = Configurable.new(length_encoding: SubEncoding::ASCII)
      codec.decode_length(codec.encode_length(12, 2), 2).should eq 12
    end

    it "round-trips BCD length prefixes" do
      codec = Configurable.new(length_encoding: SubEncoding::BCD)
      codec.decode_length(codec.encode_length(123, 3), 3).should eq 123
    end

    it "round-trips EBCDIC length prefixes" do
      codec = Configurable.new(length_encoding: SubEncoding::EBCDIC)
      codec.decode_length(codec.encode_length(12, 2), 2).should eq 12
    end

    it "round-trips Binary length prefixes as a single byte by default, for LLVAR and LLLVAR alike" do
      codec = Configurable.new(length_encoding: SubEncoding::Binary)
      codec.length_byte_size(2).should eq 1
      codec.length_byte_size(3).should eq 1
      encoded = codec.encode_length(9, 2)
      encoded.should eq Bytes[0x09]
      codec.decode_length(encoded, 2).should eq 9
      codec.decode_length(codec.encode_length(34, 3), 3).should eq 34
    end

    it "supports a wider binary_length_byte_size for fields needing it" do
      codec = Configurable.new(length_encoding: SubEncoding::Binary, binary_length_byte_size: 2)
      codec.length_byte_size(3).should eq 2
      encoded = codec.encode_length(260, 3)
      codec.decode_length(encoded, 3).should eq 260
    end
  end

  describe "numeric field data" do
    it "round-trips ASCII numeric fields" do
      codec = Configurable.new(numeric_encoding: SubEncoding::ASCII)
      encoded = codec.encode_field("1234", DataType::N)
      codec.decode_field(encoded, DataType::N, 4).should eq "1234"
    end

    it "round-trips BCD numeric fields" do
      codec = Configurable.new(numeric_encoding: SubEncoding::BCD)
      encoded = codec.encode_field("1234", DataType::N)
      codec.field_byte_size(4, DataType::N).should eq 2
      codec.decode_field(encoded, DataType::N, 4).should eq "1234"
    end

    it "round-trips EBCDIC numeric fields" do
      codec = Configurable.new(numeric_encoding: SubEncoding::EBCDIC)
      encoded = codec.encode_field("1234", DataType::N)
      codec.decode_field(encoded, DataType::N, 4).should eq "1234"
    end
  end

  describe "text field data" do
    it "round-trips ASCII text fields" do
      codec = Configurable.new(text_encoding: SubEncoding::ASCII)
      encoded = codec.encode_field("HELLO", DataType::ANS)
      codec.decode_field(encoded, DataType::ANS, 5).should eq "HELLO"
    end

    it "round-trips EBCDIC text fields" do
      codec = Configurable.new(text_encoding: SubEncoding::EBCDIC)
      encoded = codec.encode_field("HELLO", DataType::ANS)
      codec.decode_field(encoded, DataType::ANS, 5).should eq "HELLO"
    end
  end

  it "always treats binary field data as raw bytes regardless of other settings" do
    codec = Configurable.new(numeric_encoding: SubEncoding::BCD, text_encoding: SubEncoding::EBCDIC)
    encoded = codec.encode_field("aabb", DataType::B)
    encoded.should eq Bytes[0xaa, 0xbb]
    codec.decode_field(encoded, DataType::B, 2).should eq "aabb"
  end

  it "rejects an invalid mti_encoding" do
    expect_raises(ArgumentError) { Configurable.new(mti_encoding: SubEncoding::Binary) }
  end

  it "rejects an invalid numeric_encoding" do
    expect_raises(ArgumentError) { Configurable.new(numeric_encoding: SubEncoding::Binary) }
  end

  it "rejects an invalid text_encoding" do
    expect_raises(ArgumentError) { Configurable.new(text_encoding: SubEncoding::BCD) }
  end
end
