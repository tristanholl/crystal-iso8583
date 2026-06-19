require "../../spec_helper"

describe CrystalIso8583::V1987::Msg0130 do
  describe "mti_string" do
    it "is 0130" do
      CrystalIso8583::V1987::Msg0130.new.mti_string.should eq "0130"
    end
  end

  describe "validate!" do
    it "raises when required fields are missing" do
      expect_raises(CrystalIso8583::Shared::BuildError) do
        CrystalIso8583::V1987::Msg0130.new.validate!
      end
    end

    it "passes when all mandatory fields are set" do
      msg = CrystalIso8583::V1987::Msg0130.new
      msg.iso011 = "000001"
      msg.iso012 = "120000"
      msg.iso013 = "0615"
      msg.iso039 = "00"
      msg.iso090 = "0".rjust(42, '0')
      msg.validate!
    end
  end
end
