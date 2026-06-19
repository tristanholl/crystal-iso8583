require "../../spec_helper"

describe CrystalIso8583::V1987::Msg0804 do
  describe "mti_string" do
    it "is 0804" do
      CrystalIso8583::V1987::Msg0804.new.mti_string.should eq "0804"
    end
  end

  describe "validate!" do
    it "raises when required fields are missing" do
      expect_raises(CrystalIso8583::Shared::BuildError) do
        CrystalIso8583::V1987::Msg0804.new.validate!
      end
    end

    it "passes when all mandatory fields are set" do
      msg = CrystalIso8583::V1987::Msg0804.new
      msg.iso007 = "0615120000"
      msg.iso011 = "000001"
      msg.iso070 = "001"
      msg.validate!
    end
  end

  describe "build and parse round-trip" do
    it "round-trips with ASCII codec" do
      msg = CrystalIso8583::V1987::Msg0804.new
      msg.iso007 = "0615120000"
      msg.iso011 = "000001"
      msg.iso070 = "001"

      codec = CrystalIso8583::Shared::Codec::ASCII.new
      bytes = msg.build(codec)
      parsed = CrystalIso8583::V1987::Msg0804.parse(bytes, codec)

      parsed.iso011.should eq "000001"
      parsed.iso070.should eq "001"
    end
  end
end
