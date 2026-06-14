require "../../spec_helper"

describe CrystalIso8583::V1993::Msg1430 do
  describe "mti_string" do
    it "is 1430" do
      CrystalIso8583::V1993::Msg1430.new.mti_string.should eq "1430"
    end
  end

  describe "field accessors" do
    it "sets and gets action code (3-digit)" do
      msg = CrystalIso8583::V1993::Msg1430.new
      msg.iso039 = "400"
      msg.iso039.should eq "400"
    end

    it "sets and gets original data elements (BMP 56)" do
      msg = CrystalIso8583::V1993::Msg1430.new
      msg.iso056 = "11001234562606181200000272001234"
      msg.iso056.should eq "11001234562606181200000272001234"
    end
  end

  describe "validate!" do
    it "raises when required fields are missing" do
      expect_raises(CrystalIso8583::Shared::BuildError) do
        CrystalIso8583::V1993::Msg1430.new.validate!
      end
    end

    it "passes when iso007 and iso039 are set" do
      msg = CrystalIso8583::V1993::Msg1430.new
      msg.iso007 = "0618120000"
      msg.iso039 = "400"
      msg.validate!
    end

    it "requires iso039 (Action Code)" do
      msg = CrystalIso8583::V1993::Msg1430.new
      msg.iso007 = "0618120000"
      expect_raises(CrystalIso8583::Shared::BuildError) do
        msg.validate!
      end
    end
  end
end
