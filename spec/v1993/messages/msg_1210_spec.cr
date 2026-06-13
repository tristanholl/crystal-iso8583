require "../../spec_helper"

describe CrystalIso8583::V1993::Msg1210 do
  describe "mti_string" do
    it "is 1210" do
      CrystalIso8583::V1993::Msg1210.new.mti_string.should eq "1210"
    end
  end

  describe "field accessors" do
    it "sets and gets response code" do
      msg = CrystalIso8583::V1993::Msg1210.new
      msg.iso039 = "00"
      msg.iso039.should eq "00"
    end

    it "sets and gets authorization ID" do
      msg = CrystalIso8583::V1993::Msg1210.new
      msg.iso038 = "123456"
      msg.iso038.should eq "123456"
    end
  end

  describe "validate!" do
    it "raises when required fields are missing" do
      expect_raises(CrystalIso8583::Shared::BuildError) do
        CrystalIso8583::V1993::Msg1210.new.validate!
      end
    end

    it "passes when iso003, iso004, iso039 are set" do
      msg = CrystalIso8583::V1993::Msg1210.new
      msg.iso003 = "000000"
      msg.iso004 = "000000000100"
      msg.iso039 = "00"
      msg.validate!
    end

    it "does not require iso002 (PAN)" do
      msg = CrystalIso8583::V1993::Msg1210.new
      msg.iso003 = "000000"
      msg.iso004 = "000000000100"
      msg.iso039 = "00"
      msg.iso002.should be_nil
      msg.validate!
    end
  end
end
