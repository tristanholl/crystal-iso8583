require "../../spec_helper"

describe CrystalIso8583::V1987::Msg0121 do
  describe "mti_string" do
    it "is 0121" do
      CrystalIso8583::V1987::Msg0121.new.mti_string.should eq "0121"
    end
  end

  describe "validate!" do
    it "raises when required fields are missing" do
      expect_raises(CrystalIso8583::Shared::BuildError) do
        CrystalIso8583::V1987::Msg0121.new.validate!
      end
    end

    it "passes when all mandatory fields are set" do
      msg = CrystalIso8583::V1987::Msg0121.new
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

  describe "field_meta isolation" do
    it "is identical to Msg0120 except the MTI" do
      v0120 = CrystalIso8583::V1987::Msg0120.new.field_meta.keys.sort
      v0121 = CrystalIso8583::V1987::Msg0121.new.field_meta.keys.sort
      v0121.should eq v0120
    end
  end
end
