require "../../spec_helper"

describe CrystalIso8583::V1987::Msg0420 do
  describe "mti_string" do
    it "is 0420" do
      CrystalIso8583::V1987::Msg0420.new.mti_string.should eq "0420"
    end
  end

  describe "validate!" do
    it "raises when required fields are missing" do
      expect_raises(CrystalIso8583::Shared::BuildError) do
        CrystalIso8583::V1987::Msg0420.new.validate!
      end
    end

    it "passes when all mandatory fields are set" do
      msg = CrystalIso8583::V1987::Msg0420.new
      msg.iso002 = "4111111111111111"
      msg.iso003 = "000000"
      msg.iso004 = "000000001000"
      msg.iso007 = "0615120000"
      msg.iso011 = "000001"
      msg.iso012 = "120000"
      msg.iso013 = "0615"
      msg.iso041 = "TERM0001"
      msg.iso042 = "MERCH001       "
      msg.iso049 = "840"
      msg.iso090 = "0".rjust(42, '0')
      msg.validate!
    end
  end

  describe "build and parse round-trip" do
    it "round-trips with ASCII codec" do
      msg = CrystalIso8583::V1987::Msg0420.new
      msg.iso002 = "4111111111111111"
      msg.iso003 = "000000"
      msg.iso004 = "000000001000"
      msg.iso007 = "0615120000"
      msg.iso011 = "000001"
      msg.iso012 = "120000"
      msg.iso013 = "0615"
      msg.iso041 = "TERM0001"
      msg.iso042 = "MERCH001       "
      msg.iso049 = "840"
      msg.iso090 = "1".rjust(42, '0')

      codec = CrystalIso8583::Shared::Codec::ASCII.new
      bytes = msg.build(codec)
      parsed = CrystalIso8583::V1987::Msg0420.parse(bytes, codec)

      parsed.iso002.should eq "4111111111111111"
      parsed.iso090.should eq "1".rjust(42, '0')
    end
  end
end
