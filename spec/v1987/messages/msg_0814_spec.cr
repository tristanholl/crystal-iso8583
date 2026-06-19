require "../../spec_helper"

describe CrystalIso8583::V1987::Msg0814 do
  describe "mti_string" do
    it "is 0814" do
      CrystalIso8583::V1987::Msg0814.new.mti_string.should eq "0814"
    end
  end

  describe "validate!" do
    it "raises when required fields are missing" do
      expect_raises(CrystalIso8583::Shared::BuildError) do
        CrystalIso8583::V1987::Msg0814.new.validate!
      end
    end

    it "passes when all mandatory fields are set" do
      msg = CrystalIso8583::V1987::Msg0814.new
      msg.iso007 = "0615120000"
      msg.iso011 = "000001"
      msg.iso039 = "00"
      msg.iso070 = "001"
      msg.validate!
    end
  end
end
