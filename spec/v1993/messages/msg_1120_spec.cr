require "../../spec_helper"

describe CrystalIso8583::V1993::Msg1120 do
  describe "mti_string" do
    it "is 1120" do
      CrystalIso8583::V1993::Msg1120.new.mti_string.should eq "1120"
    end
  end

  describe "validate!" do
    it "raises when required fields are missing" do
      expect_raises(CrystalIso8583::Shared::BuildError) do
        CrystalIso8583::V1993::Msg1120.new.validate!
      end
    end

    it "passes when all mandatory fields are set" do
      msg = CrystalIso8583::V1993::Msg1120.new
      msg.iso003 = "000000"
      msg.iso004 = "000000000100"
      msg.iso007 = "0618120000"
      msg.iso011 = "000001"
      msg.iso012 = "260618120000"
      msg.iso024 = "180"
      msg.iso041 = "TERM0001"
      msg.iso042 = "MERCH001       "
      msg.iso056 = "11001234562606181200000272001234"
      msg.validate!
    end
  end
end
