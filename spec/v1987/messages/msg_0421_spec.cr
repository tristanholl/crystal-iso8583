require "../../spec_helper"

describe CrystalISO8583::V1987::Msg0421 do
  describe "mti_string" do
    it "is 0421" do
      CrystalISO8583::V1987::Msg0421.new.mti_string.should eq "0421"
    end
  end

  describe "validate!" do
    it "raises when required fields are missing" do
      expect_raises(CrystalISO8583::Shared::BuildError) do
        CrystalISO8583::V1987::Msg0421.new.validate!
      end
    end

    it "passes when all mandatory fields are set" do
      msg = CrystalISO8583::V1987::Msg0421.new
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
    it "is identical to Msg0420 except the MTI" do
      v0420 = CrystalISO8583::V1987::Msg0420.new.field_meta.keys.sort
      v0421 = CrystalISO8583::V1987::Msg0421.new.field_meta.keys.sort
      v0421.should eq v0420
    end
  end
end
