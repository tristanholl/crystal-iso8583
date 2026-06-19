require "../../spec_helper"

describe CrystalIso8583::V1993::Msg1110 do
  describe "mti_string" do
    it "is 1110" do
      CrystalIso8583::V1993::Msg1110.new.mti_string.should eq "1110"
    end
  end

  describe "validate!" do
    it "raises when required fields are missing" do
      expect_raises(CrystalIso8583::Shared::BuildError) do
        CrystalIso8583::V1993::Msg1110.new.validate!
      end
    end

    it "passes when iso039 is set" do
      msg = CrystalIso8583::V1993::Msg1110.new
      msg.iso007 = "0618120000"
      msg.iso039 = "000"
      msg.validate!
    end

    it "does not require iso002 (PAN)" do
      msg = CrystalIso8583::V1993::Msg1110.new
      msg.iso007 = "0618120000"
      msg.iso039 = "000"
      msg.iso002.should be_nil
      msg.validate!
    end
  end
end
