require "../spec_helper"

describe CrystalIso8583::Shared::Generator do
  dict = CrystalIso8583::V1993::DataDictionary.fields

  describe "#generate with ASCII codec" do
    codec = CrystalIso8583::Shared::Codec::ASCII.new
    generator = CrystalIso8583::Shared::Generator.new(dict, codec)
    parser = CrystalIso8583::Shared::Parser.new(dict, codec)

    it "encodes the MTI" do
      bytes = generator.generate("1100", {3 => "310000", 7 => "0618120000"})
      message = parser.parse(bytes)
      message.mti.to_s.should eq "1100"
    end

    it "round-trips FIXED numeric fields" do
      fields = {3 => "310000", 7 => "0618120000", 11 => "000001"}
      message = parser.parse(generator.generate("1100", fields))
      message.fields[3].decoded.should eq "310000"
      message.fields[7].decoded.should eq "0618120000"
      message.fields[11].decoded.should eq "000001"
    end

    it "round-trips FIXED alphanumeric fields" do
      fields = {37 => "123456789012", 38 => "ABCDEF"}
      message = parser.parse(generator.generate("1110", fields))
      message.fields[37].decoded.should eq "123456789012"
      message.fields[38].decoded.should eq "ABCDEF"
    end

    it "round-trips LLVAR numeric fields" do
      fields = {2 => "4349710000001380", 32 => "12345678"}
      message = parser.parse(generator.generate("1100", fields))
      message.fields[2].decoded.should eq "4349710000001380"
      message.fields[32].decoded.should eq "12345678"
    end

    it "round-trips LLLVAR alphanumeric fields" do
      fields = {48 => "PRIVATE DATA FOR TESTING"}
      message = parser.parse(generator.generate("1100", fields))
      message.fields[48].decoded.should eq "PRIVATE DATA FOR TESTING"
    end

    it "round-trips binary fields as hex strings" do
      fields = {64 => "0102030405060708"}
      message = parser.parse(generator.generate("1100", fields))
      message.fields[64].decoded.should eq "0102030405060708"
    end

    it "only includes fields present in the input hash" do
      fields = {3 => "000000", 7 => "0618120000"}
      message = parser.parse(generator.generate("1100", fields))
      message.fields.has_key?(2).should be_false
      message.fields.has_key?(11).should be_false
    end

    it "raises BuildError for a field ID not in the dictionary" do
      expect_raises(CrystalIso8583::Shared::BuildError) do
        generator.generate("1100", {999 => "DATA"})
      end
    end

    it "raises ArgumentError for an invalid MTI" do
      expect_raises(ArgumentError) do
        generator.generate("XXXX", {3 => "310000"})
      end
    end
  end

  describe "#generate with BCD codec" do
    codec = CrystalIso8583::Shared::Codec::BCD.new
    generator = CrystalIso8583::Shared::Generator.new(dict, codec)
    parser = CrystalIso8583::Shared::Parser.new(dict, codec)

    it "round-trips FIXED numeric fields" do
      fields = {3 => "310000", 7 => "0618120000", 11 => "000001"}
      message = parser.parse(generator.generate("1100", fields))
      message.mti.to_s.should eq "1100"
      message.fields[3].decoded.should eq "310000"
      message.fields[7].decoded.should eq "0618120000"
      message.fields[11].decoded.should eq "000001"
    end

    it "round-trips LLVAR numeric fields" do
      fields = {2 => "4349710000001380", 32 => "12345678"}
      message = parser.parse(generator.generate("1100", fields))
      message.fields[2].decoded.should eq "4349710000001380"
      message.fields[32].decoded.should eq "12345678"
    end

    it "round-trips binary fields" do
      fields = {64 => "aabbccddeeff0011"}
      message = parser.parse(generator.generate("1100", fields))
      message.fields[64].decoded.should eq "aabbccddeeff0011"
    end

    it "produces a smaller message than ASCII for numeric-heavy data" do
      fields = {3 => "310000", 7 => "0618120000", 11 => "000001", 4 => "000000001000"}
      ascii_codec = CrystalIso8583::Shared::Codec::ASCII.new
      ascii_gen = CrystalIso8583::Shared::Generator.new(dict, ascii_codec)
      bcd_bytes = generator.generate("1100", fields)
      ascii_bytes = ascii_gen.generate("1100", fields)
      bcd_bytes.size.should be < ascii_bytes.size
    end
  end

  describe "#generate with EBCDIC codec" do
    codec = CrystalIso8583::Shared::Codec::EBCDIC.new
    generator = CrystalIso8583::Shared::Generator.new(dict, codec)
    parser = CrystalIso8583::Shared::Parser.new(dict, codec)

    it "round-trips FIXED alphanumeric fields" do
      fields = {37 => "123456789012", 38 => "ABCDEF", 41 => "TERM0001"}
      message = parser.parse(generator.generate("1110", fields))
      message.fields[37].decoded.should eq "123456789012"
      message.fields[38].decoded.should eq "ABCDEF"
      message.fields[41].decoded.should eq "TERM0001"
    end

    it "round-trips LLVAR alphanumeric fields" do
      fields = {43 => "MY STORE / 123 MAIN ST / CITY / US"}
      message = parser.parse(generator.generate("1100", fields))
      message.fields[43].decoded.should eq "MY STORE / 123 MAIN ST / CITY / US"
    end
  end

  describe "#generate produces correct bitmap" do
    codec = CrystalIso8583::Shared::Codec::ASCII.new
    generator = CrystalIso8583::Shared::Generator.new(dict, codec)
    parser = CrystalIso8583::Shared::Parser.new(dict, codec)

    it "sets secondary bitmap when a field above 64 is present" do
      fields = {3 => "310000", 112 => "NATIONAL DATA"}
      message = parser.parse(generator.generate("1100", fields))
      message.bitmap.has_secondary?.should be_true
      message.fields[112].decoded.should eq "NATIONAL DATA"
    end

    it "omits secondary bitmap when all fields are in 1-64" do
      fields = {3 => "310000", 7 => "0618120000"}
      message = parser.parse(generator.generate("1100", fields))
      message.bitmap.has_secondary?.should be_false
    end
  end
end
