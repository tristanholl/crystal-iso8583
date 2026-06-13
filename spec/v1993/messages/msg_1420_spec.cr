require "../../spec_helper"

describe CrystalIso8583::V1993::Msg1420 do
  describe "mti_string" do
    it "is 1420" do
      CrystalIso8583::V1993::Msg1420.new.mti_string.should eq "1420"
    end
  end

  describe "field accessors" do
    it "sets and gets original data elements" do
      msg = CrystalIso8583::V1993::Msg1420.new
      msg.iso090 = "110012345600000000000000000000000000000000"
      msg.iso090.should eq "110012345600000000000000000000000000000000"
    end

    it "sets and gets replacement amounts" do
      msg = CrystalIso8583::V1993::Msg1420.new
      msg.iso095 = "000000000000000000000000000000000000000000"
      msg.iso095.should eq "000000000000000000000000000000000000000000"
    end
  end

  describe "validate!" do
    it "raises when required fields are missing" do
      expect_raises(CrystalIso8583::Shared::BuildError) do
        CrystalIso8583::V1993::Msg1420.new.validate!
      end
    end

    it "passes when iso003, iso004, iso090 are set" do
      msg = CrystalIso8583::V1993::Msg1420.new
      msg.iso003 = "000000"
      msg.iso004 = "000000000100"
      msg.iso090 = "110012345600000000000000000000000000000000"
      msg.validate!
    end

    it "does not require iso039 (Response Code)" do
      msg = CrystalIso8583::V1993::Msg1420.new
      msg.iso003 = "000000"
      msg.iso004 = "000000000100"
      msg.iso090 = "110012345600000000000000000000000000000000"
      msg.iso039.should be_nil
      msg.validate!
    end
  end
end
