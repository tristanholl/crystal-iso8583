require "../../spec_helper"

describe CrystalIso8583::V1993::Msg1200 do
  describe "mti_string" do
    it "is 1200" do
      CrystalIso8583::V1993::Msg1200.new.mti_string.should eq "1200"
    end
  end

  describe "field accessors" do
    it "sets and gets PAN" do
      msg = CrystalIso8583::V1993::Msg1200.new
      msg.iso002 = "4111111111111111"
      msg.iso002.should eq "4111111111111111"
    end

    it "sets and gets merchant fields" do
      msg = CrystalIso8583::V1993::Msg1200.new
      msg.iso041 = "TERMID01"
      msg.iso042 = "CARD ACCEPTOR  "
      msg.iso043 = "MERCHANT NAME\\\\CITY\\             USA"
      msg.iso041.should eq "TERMID01"
      msg.iso043.should eq "MERCHANT NAME\\\\CITY\\             USA"
    end
  end

  describe "validate!" do
    it "raises when required fields are missing" do
      expect_raises(CrystalIso8583::Shared::BuildError) do
        CrystalIso8583::V1993::Msg1200.new.validate!
      end
    end

    it "passes when iso002, iso003, iso004 are set" do
      msg = CrystalIso8583::V1993::Msg1200.new
      msg.iso002 = "4111111111111111"
      msg.iso003 = "000000"
      msg.iso004 = "000000000100"
      msg.validate!
    end
  end
end
