require "../spec_helper"

describe CrystalISO8583::Shared::BCDUtil do
  describe ".pack" do
    it "packs an even-length digit string two digits per byte" do
      CrystalISO8583::Shared::BCDUtil.pack("1234").should eq Bytes[0x12, 0x34]
    end

    it "left-pads an odd-length digit string with a zero nibble" do
      CrystalISO8583::Shared::BCDUtil.pack("123").should eq Bytes[0x01, 0x23]
    end
  end

  describe ".unpack" do
    it "unpacks bytes into a digit string" do
      CrystalISO8583::Shared::BCDUtil.unpack(Bytes[0x12, 0x34]).should eq "1234"
    end
  end

  it "round-trips pack/unpack for even-length digits" do
    digits = "0100"
    CrystalISO8583::Shared::BCDUtil.unpack(CrystalISO8583::Shared::BCDUtil.pack(digits)).should eq digits
  end

  describe ".pack_track2" do
    it "packs digits and the '=' separator two characters per byte" do
      CrystalISO8583::Shared::BCDUtil.pack_track2("1234=5678").should eq Bytes[0x12, 0x34, 0xD5, 0x67, 0x8F]
    end

    it "pads an odd-length track 2 string with a trailing 0xF nibble" do
      CrystalISO8583::Shared::BCDUtil.pack_track2("123").should eq Bytes[0x12, 0x3F]
    end
  end

  describe ".unpack_track2" do
    it "unpacks bytes back into digits and the '=' separator" do
      CrystalISO8583::Shared::BCDUtil.unpack_track2(Bytes[0x12, 0x34, 0xD5, 0x67, 0x8F]).should eq "1234=5678F"
    end
  end

  it "round-trips pack_track2/unpack_track2 for an even-length PAN=expiry style track 2 string" do
    track2 = "1234567890123456=2512101123456"
    CrystalISO8583::Shared::BCDUtil.unpack_track2(CrystalISO8583::Shared::BCDUtil.pack_track2(track2)).should eq track2
  end
end
