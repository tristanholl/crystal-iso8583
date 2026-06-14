require "../spec_helper"

private def make_message(mti : String, fields : Hash(Int32, String))
  fvs = fields.transform_values { |v| CrystalIso8583::Shared::FieldValue.new(Bytes.new(0), v) }
  CrystalIso8583::Shared::Message.new(
    mti: CrystalIso8583::Shared::MTI.parse(mti),
    bitmap: CrystalIso8583::Shared::Bitmap.new,
    fields: fvs
  )
end

describe CrystalIso8583::Shared::Builder do
  dict = CrystalIso8583::V1993::DataDictionary.fields

  describe "round-trip with ASCII codec" do
    codec = CrystalIso8583::Shared::Codec::ASCII.new
    builder = CrystalIso8583::Shared::Builder.new(dict, codec)
    parser = CrystalIso8583::Shared::Parser.new(dict, codec)

    it "encodes the MTI" do
      parsed = parser.parse(builder.build(make_message("1100", {3 => "310000"})))
      parsed.mti.to_s.should eq "1100"
    end

    it "round-trips FIXED numeric fields" do
      fields = {3 => "310000", 7 => "0618120000", 11 => "000001"}
      parsed = parser.parse(builder.build(make_message("1100", fields)))
      parsed.fields[3].decoded.should eq "310000"
      parsed.fields[7].decoded.should eq "0618120000"
      parsed.fields[11].decoded.should eq "000001"
    end

    it "round-trips FIXED alphanumeric fields" do
      fields = {37 => "123456789012", 38 => "ABCDEF", 41 => "TERM0001"}
      parsed = parser.parse(builder.build(make_message("1110", fields)))
      parsed.fields[37].decoded.should eq "123456789012"
      parsed.fields[38].decoded.should eq "ABCDEF"
      parsed.fields[41].decoded.should eq "TERM0001"
    end

    it "round-trips LLVAR numeric fields" do
      fields = {2 => "4349710000001380", 32 => "12345678"}
      parsed = parser.parse(builder.build(make_message("1100", fields)))
      parsed.fields[2].decoded.should eq "4349710000001380"
      parsed.fields[32].decoded.should eq "12345678"
    end

    it "round-trips LLLVAR alphanumeric fields" do
      fields = {48 => "PRIVATE DATA FOR TESTING"}
      parsed = parser.parse(builder.build(make_message("1100", fields)))
      parsed.fields[48].decoded.should eq "PRIVATE DATA FOR TESTING"
    end

    it "round-trips FIXED binary fields" do
      fields = {64 => "0102030405060708"}
      parsed = parser.parse(builder.build(make_message("1100", fields)))
      parsed.fields[64].decoded.should eq "0102030405060708"
    end

    it "only includes fields present in the input hash" do
      fields = {3 => "000000", 7 => "0618120000"}
      parsed = parser.parse(builder.build(make_message("1100", fields)))
      parsed.fields.has_key?(2).should be_false
      parsed.fields.has_key?(11).should be_false
    end
  end

  describe "round-trip with BCD codec" do
    codec = CrystalIso8583::Shared::Codec::BCD.new
    builder = CrystalIso8583::Shared::Builder.new(dict, codec)
    parser = CrystalIso8583::Shared::Parser.new(dict, codec)

    it "round-trips FIXED numeric fields" do
      fields = {3 => "310000", 7 => "0618120000", 11 => "000001"}
      parsed = parser.parse(builder.build(make_message("1100", fields)))
      parsed.mti.to_s.should eq "1100"
      parsed.fields[3].decoded.should eq "310000"
      parsed.fields[7].decoded.should eq "0618120000"
      parsed.fields[11].decoded.should eq "000001"
    end

    it "round-trips LLVAR numeric fields" do
      fields = {2 => "4349710000001380", 32 => "12345678"}
      parsed = parser.parse(builder.build(make_message("1100", fields)))
      parsed.fields[2].decoded.should eq "4349710000001380"
      parsed.fields[32].decoded.should eq "12345678"
    end

    it "round-trips FIXED binary fields" do
      fields = {64 => "aabbccddeeff0011"}
      parsed = parser.parse(builder.build(make_message("1100", fields)))
      parsed.fields[64].decoded.should eq "aabbccddeeff0011"
    end

    it "produces smaller output than ASCII for numeric-heavy messages" do
      fields = {3 => "310000", 7 => "0618120000", 11 => "000001", 4 => "000000001000"}
      ascii_builder = CrystalIso8583::Shared::Builder.new(dict, CrystalIso8583::Shared::Codec::ASCII.new)
      bcd_bytes = builder.build(make_message("1100", fields))
      ascii_bytes = ascii_builder.build(make_message("1100", fields))
      bcd_bytes.size.should be < ascii_bytes.size
    end
  end

  describe "round-trip with EBCDIC codec" do
    codec = CrystalIso8583::Shared::Codec::EBCDIC.new
    builder = CrystalIso8583::Shared::Builder.new(dict, codec)
    parser = CrystalIso8583::Shared::Parser.new(dict, codec)

    it "round-trips FIXED alphanumeric fields" do
      fields = {37 => "123456789012", 38 => "ABCDEF", 41 => "TERM0001"}
      parsed = parser.parse(builder.build(make_message("1110", fields)))
      parsed.fields[37].decoded.should eq "123456789012"
      parsed.fields[38].decoded.should eq "ABCDEF"
      parsed.fields[41].decoded.should eq "TERM0001"
    end

    it "round-trips LLVAR alphanumeric fields" do
      fields = {43 => "MY STORE / 123 MAIN ST / CITY / US"}
      parsed = parser.parse(builder.build(make_message("1100", fields)))
      parsed.fields[43].decoded.should eq "MY STORE / 123 MAIN ST / CITY / US"
    end
  end

  describe "bitmap" do
    codec = CrystalIso8583::Shared::Codec::ASCII.new
    builder = CrystalIso8583::Shared::Builder.new(dict, codec)
    parser = CrystalIso8583::Shared::Parser.new(dict, codec)

    it "sets secondary bitmap when a field above 64 is present" do
      fields = {3 => "310000", 112 => "NATIONAL DATA"}
      parsed = parser.parse(builder.build(make_message("1100", fields)))
      parsed.bitmap.has_secondary?.should be_true
      parsed.fields[112].decoded.should eq "NATIONAL DATA"
    end

    it "omits secondary bitmap when all fields are in 1-64" do
      fields = {3 => "310000", 7 => "0618120000"}
      parsed = parser.parse(builder.build(make_message("1100", fields)))
      parsed.bitmap.has_secondary?.should be_false
    end
  end

  describe "validation" do
    codec = CrystalIso8583::Shared::Codec::ASCII.new
    builder = CrystalIso8583::Shared::Builder.new(dict, codec)

    it "raises BuildError when a field ID is out of the 1..128 range" do
      ex = expect_raises(CrystalIso8583::Shared::BuildError) do
        builder.build(make_message("1100", {999 => "DATA"}))
      end
      ex.message.to_s.should contain "1..128"
    end

    it "raises BuildError when a numeric field contains a non-digit character" do
      ex = expect_raises(CrystalIso8583::Shared::BuildError) do
        builder.build(make_message("1100", {3 => "31A000"}))
      end
      ex.message.to_s.should contain "non-digit"
    end

    it "raises BuildError when a binary field value contains invalid hex characters" do
      ex = expect_raises(CrystalIso8583::Shared::BuildError) do
        builder.build(make_message("1100", {64 => "GGGGGGGGGGGGGGGG"}))
      end
      ex.message.to_s.should contain "lowercase hex"
    end

    it "raises BuildError when a binary field value has odd length" do
      ex = expect_raises(CrystalIso8583::Shared::BuildError) do
        builder.build(make_message("1100", {64 => "010203040506070"}))
      end
      ex.message.to_s.should contain "lowercase hex"
    end

    it "raises BuildError when a FIXED binary field has the wrong byte count" do
      ex = expect_raises(CrystalIso8583::Shared::BuildError) do
        builder.build(make_message("1100", {64 => "010203040506070809"}))
      end
      ex.message.to_s.should contain "expected exactly"
    end

    it "raises BuildError when an LLVAR value exceeds max_length" do
      # Field 2 is LLVAR, max 19 digits; 20-digit value must be rejected
      ex = expect_raises(CrystalIso8583::Shared::BuildError) do
        builder.build(make_message("1100", {2 => "12345678901234567890"}))
      end
      ex.message.to_s.should contain "exceeds maximum"
    end

    it "raises BuildError when a FIXED field value encodes to more bytes than allowed" do
      # Field 3 is FIXED N 6; a 7-digit string encodes to 7 ASCII bytes vs. 6 expected
      ex = expect_raises(CrystalIso8583::Shared::BuildError) do
        builder.build(make_message("1100", {3 => "3100001"}))
      end
      ex.message.to_s.should contain "exceeds fixed-field size"
    end

    it "includes the field label in the error message" do
      ex = expect_raises(CrystalIso8583::Shared::BuildError) do
        builder.build(make_message("1100", {3 => "31A000"}))
      end
      ex.message.to_s.should contain "Processing Code"
    end
  end
end
