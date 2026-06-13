require "../../spec_helper"

describe CrystalIso8583::V1993::Msg1110 do
  describe "mti_string" do
    it "is 1110" do
      CrystalIso8583::V1993::Msg1110.new.mti_string.should eq "1110"
    end
  end

  describe "field accessors" do
    it "sets and gets optional PAN" do
      msg = CrystalIso8583::V1993::Msg1110.new
      msg.iso002 = "434971******1380"
      msg.iso002.should eq "434971******1380"
    end

    it "sets and gets response fields" do
      msg = CrystalIso8583::V1993::Msg1110.new
      msg.iso039 = "00"
      msg.iso038 = "036246"
      msg.iso039.should eq "00"
      msg.iso038.should eq "036246"
    end
  end

  describe "validate!" do
    it "raises when required fields are missing" do
      expect_raises(CrystalIso8583::Shared::BuildError) do
        CrystalIso8583::V1993::Msg1110.new.validate!
      end
    end

    it "passes when iso003, iso004, iso039 are set" do
      msg = CrystalIso8583::V1993::Msg1110.new
      msg.iso003 = "000000"
      msg.iso004 = "000000000100"
      msg.iso039 = "00"
      msg.validate!
    end

    it "does not require iso002 (PAN)" do
      msg = CrystalIso8583::V1993::Msg1110.new
      msg.iso003 = "000000"
      msg.iso004 = "000000000100"
      msg.iso039 = "00"
      msg.iso002.should be_nil
      msg.validate!
    end
  end
end
