require "../../spec_helper"

describe CrystalIso8583::V1993::Msg1130 do
  describe "mti_string" do
    it "is 1130" do
      CrystalIso8583::V1993::Msg1130.new.mti_string.should eq "1130"
    end
  end

  describe "field accessors" do
    it "sets and gets action code (3-digit)" do
      msg = CrystalIso8583::V1993::Msg1130.new
      msg.iso039 = "800"
      msg.iso039.should eq "800"
    end
  end

  describe "validate!" do
    it "raises when required fields are missing" do
      expect_raises(CrystalIso8583::Shared::BuildError) do
        CrystalIso8583::V1993::Msg1130.new.validate!
      end
    end

    it "passes when iso007 and iso039 are set" do
      msg = CrystalIso8583::V1993::Msg1130.new
      msg.iso007 = "0618120000"
      msg.iso039 = "800"
      msg.validate!
    end
  end
end
