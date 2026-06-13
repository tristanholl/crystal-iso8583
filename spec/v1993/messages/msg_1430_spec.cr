require "../../spec_helper"

describe CrystalIso8583::V1993::Msg1430 do
  describe "mti_string" do
    it "is 1430" do
      CrystalIso8583::V1993::Msg1430.new.mti_string.should eq "1430"
    end
  end

  describe "field accessors" do
    it "sets and gets response code" do
      msg = CrystalIso8583::V1993::Msg1430.new
      msg.iso039 = "40"
      msg.iso039.should eq "40"
    end

    it "sets and gets original data elements" do
      msg = CrystalIso8583::V1993::Msg1430.new
      msg.iso090 = "110012345600000000000000000000000000000000"
      msg.iso090.should eq "110012345600000000000000000000000000000000"
    end
  end

  describe "validate!" do
    it "raises when required fields are missing" do
      expect_raises(CrystalIso8583::Shared::BuildError) do
        CrystalIso8583::V1993::Msg1430.new.validate!
      end
    end

    it "passes when iso003, iso004, iso039, iso090 are set" do
      msg = CrystalIso8583::V1993::Msg1430.new
      msg.iso003 = "000000"
      msg.iso004 = "000000000100"
      msg.iso039 = "40"
      msg.iso090 = "110012345600000000000000000000000000000000"
      msg.validate!
    end

    it "requires iso039 unlike Msg1420" do
      msg = CrystalIso8583::V1993::Msg1430.new
      msg.iso003 = "000000"
      msg.iso004 = "000000000100"
      msg.iso090 = "110012345600000000000000000000000000000000"
      expect_raises(CrystalIso8583::Shared::BuildError) do
        msg.validate!
      end
    end
  end
end
