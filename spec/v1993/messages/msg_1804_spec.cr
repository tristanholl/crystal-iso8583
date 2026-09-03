require "../../spec_helper"

describe CrystalISO8583::V1993::Msg1804 do
  describe "mti_string" do
    it "is 1804" do
      CrystalISO8583::V1993::Msg1804.new.mti_string.should eq "1804"
    end
  end

  describe "validate!" do
    it "raises when required fields are missing" do
      expect_raises(CrystalISO8583::Shared::BuildError) do
        CrystalISO8583::V1993::Msg1804.new.validate!
      end
    end

    it "passes when all mandatory fields are set" do
      msg = CrystalISO8583::V1993::Msg1804.new
      msg.iso011 = "000001"
      msg.iso012 = "260618120000"
      msg.iso024 = "831"
      msg.iso025 = "0000"
      msg.iso093 = "27200"
      msg.iso094 = "27201"
      msg.iso128 = "0000000000000000"
      msg.validate!
    end
  end
end
