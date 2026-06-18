require "../spec_helper"

describe CrystalIso8583::Shared::BCDUtil do
  describe ".pack" do
    it "packs an even-length digit string two digits per byte" do
      CrystalIso8583::Shared::BCDUtil.pack("1234").should eq Bytes[0x12, 0x34]
    end

    it "left-pads an odd-length digit string with a zero nibble" do
      CrystalIso8583::Shared::BCDUtil.pack("123").should eq Bytes[0x01, 0x23]
    end
  end

  describe ".unpack" do
    it "unpacks bytes into a digit string" do
      CrystalIso8583::Shared::BCDUtil.unpack(Bytes[0x12, 0x34]).should eq "1234"
    end
  end

  it "round-trips pack/unpack for even-length digits" do
    digits = "0100"
    CrystalIso8583::Shared::BCDUtil.unpack(CrystalIso8583::Shared::BCDUtil.pack(digits)).should eq digits
  end
end
