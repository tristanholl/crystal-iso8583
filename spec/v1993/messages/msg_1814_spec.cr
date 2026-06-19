require "../../spec_helper"

describe CrystalIso8583::V1993::Msg1814 do
  describe "mti_string" do
    it "is 1814" do
      CrystalIso8583::V1993::Msg1814.new.mti_string.should eq "1814"
    end
  end

  describe "validate!" do
    it "raises when required fields are missing" do
      expect_raises(CrystalIso8583::Shared::BuildError) do
        CrystalIso8583::V1993::Msg1814.new.validate!
      end
    end

    it "passes when all mandatory fields are set" do
      msg = CrystalIso8583::V1993::Msg1814.new
      msg.iso011 = "000001"
      msg.iso012 = "260618120000"
      msg.iso039 = "800"
      msg.iso093 = "27200"
      msg.iso094 = "27201"
      msg.iso128 = "0000000000000000"
      msg.validate!
    end
  end
end
