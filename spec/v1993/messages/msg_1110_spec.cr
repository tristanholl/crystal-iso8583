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

    it "sets and gets action code (3-digit) and approval code" do
      msg = CrystalIso8583::V1993::Msg1110.new
      msg.iso039 = "000"
      msg.iso038 = "036246"
      msg.iso039.should eq "000"
      msg.iso038.should eq "036246"
    end

    it "sets and gets card issuer reference data" do
      msg = CrystalIso8583::V1993::Msg1110.new
      msg.iso095 = "ISSUERREF001"
      msg.iso095.should eq "ISSUERREF001"
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
