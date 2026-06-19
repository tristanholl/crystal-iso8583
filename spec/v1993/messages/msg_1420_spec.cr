require "../../spec_helper"

describe CrystalIso8583::V1993::Msg1420 do
  describe "mti_string" do
    it "is 1420" do
      CrystalIso8583::V1993::Msg1420.new.mti_string.should eq "1420"
    end
  end

  describe "validate!" do
    it "raises when required fields are missing" do
      expect_raises(CrystalIso8583::Shared::BuildError) do
        CrystalIso8583::V1993::Msg1420.new.validate!
      end
    end

    it "passes when all mandatory fields are set" do
      msg = CrystalIso8583::V1993::Msg1420.new
      msg.iso002 = "4111111111111111"
      msg.iso003 = "000000"
      msg.iso004 = "000000000100"
      msg.iso007 = "0618120000"
      msg.iso011 = "000001"
      msg.iso012 = "260618120000"
      msg.iso024 = "400"
      msg.iso025 = "4021"
      msg.iso032 = "27200"
      msg.iso037 = "000000000001"
      msg.iso056 = "11001234562606181200000272001234"
      msg.validate!
    end

    it "does not require an Action Code (unlike Msg1430)" do
      msg = CrystalIso8583::V1993::Msg1420.new
      msg.iso002 = "4111111111111111"
      msg.iso003 = "000000"
      msg.iso004 = "000000000100"
      msg.iso007 = "0618120000"
      msg.iso011 = "000001"
      msg.iso012 = "260618120000"
      msg.iso024 = "400"
      msg.iso025 = "4021"
      msg.iso032 = "27200"
      msg.iso037 = "000000000001"
      msg.iso056 = "11001234562606181200000272001234"
      msg.validate!
    end
  end
end
