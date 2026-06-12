require "../spec_helper"

describe ISO8583::Shared::Bitmap do
  describe ".build + field_present?" do
    it "sets bits for the given fields" do
      bmp = ISO8583::Shared::Bitmap.build([2, 3, 4, 11])
      bmp.field_present?(2).should be_true
      bmp.field_present?(3).should be_true
      bmp.field_present?(4).should be_true
      bmp.field_present?(11).should be_true
      bmp.field_present?(5).should be_false
      bmp.field_present?(64).should be_false
    end

    it "produces an 8-byte primary-only bitmap when all fields <= 64" do
      bmp = ISO8583::Shared::Bitmap.build([2, 63, 64])
      bmp.bytes.size.should eq 8
      bmp.has_secondary?.should be_false
    end

    it "produces a 16-byte bitmap and sets bit 1 when any field > 64" do
      bmp = ISO8583::Shared::Bitmap.build([2, 65])
      bmp.bytes.size.should eq 16
      bmp.has_secondary?.should be_true
      bmp.field_present?(1).should be_true   # secondary bitmap indicator
      bmp.field_present?(2).should be_true
      bmp.field_present?(65).should be_true
    end

    it "ignores field 1 in input (set automatically by secondary logic)" do
      bmp_without = ISO8583::Shared::Bitmap.build([2])
      bmp_with    = ISO8583::Shared::Bitmap.build([1, 2])
      bmp_without.bytes.should eq bmp_with.bytes
    end
  end

  describe ".parse" do
    it "parses a primary-only bitmap" do
      # DE 2 (bit 2 = 0x40), DE 4 (bit 4 = 0x10) => byte 0 = 0x50
      raw = Bytes[0x50, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00]
      bmp = ISO8583::Shared::Bitmap.parse(IO::Memory.new(raw))
      bmp.field_present?(2).should be_true
      bmp.field_present?(4).should be_true
      bmp.field_present?(3).should be_false
      bmp.bytes.size.should eq 8
    end

    it "parses primary + secondary bitmap when bit 1 is set" do
      primary   = Bytes[0x80, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00]
      secondary = Bytes[0x40, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00]
      raw = primary + secondary
      bmp = ISO8583::Shared::Bitmap.parse(IO::Memory.new(raw))
      bmp.bytes.size.should eq 16
      bmp.field_present?(65).should be_true   # bit 1 of secondary = field 65
    end
  end

  describe "present_fields" do
    it "returns all set field numbers in order" do
      bmp = ISO8583::Shared::Bitmap.build([2, 11, 39, 49])
      bmp.present_fields.should eq [2, 11, 39, 49]
    end
  end

  describe "round-trip write/parse" do
    it "survives build -> write -> parse unchanged" do
      fields = [2, 3, 4, 7, 11, 41, 42, 49]
      original = ISO8583::Shared::Bitmap.build(fields)
      io = IO::Memory.new
      original.write(io)
      io.rewind
      parsed = ISO8583::Shared::Bitmap.parse(io)
      parsed.bytes.should eq original.bytes
    end
  end
end
