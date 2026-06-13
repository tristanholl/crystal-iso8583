require "../../spec_helper"

describe CrystalIso8583::V1993::Msg1100 do
  describe "mti_string" do
    it "is 1100" do
      CrystalIso8583::V1993::Msg1100.new.mti_string.should eq "1100"
    end
  end

  describe "field accessors" do
    it "sets and gets PAN" do
      msg = CrystalIso8583::V1993::Msg1100.new
      msg.iso002 = "434971******1380"
      msg.iso002.should eq "434971******1380"
    end

    it "sets and gets all fields from the CrystalCardRta example" do
      msg = CrystalIso8583::V1993::Msg1100.new
      msg.iso002 = "434971******1380"
      msg.iso003 = "310000"
      msg.iso004 = "000000000000"
      msg.iso006 = "000000000000"
      msg.iso011 = "123456"
      msg.iso012 = "210118152100"
      msg.iso014 = "2401"
      msg.iso022 = "51120181504C"
      msg.iso023 = "001"
      msg.iso024 = "108"
      msg.iso026 = "6011"
      msg.iso032 = "12345678901"
      msg.iso033 = "12928"
      msg.iso037 = "102009101490"
      msg.iso038 = "036246"
      msg.iso041 = "TERMID01"
      msg.iso042 = "CARD ACCEPTOR  "
      msg.iso049 = "978"
      msg.iso051 = "978"
      msg.iso063 = "031500000000000123456"
      msg.iso093 = "12928"
      msg.iso094 = "12345678901"
      msg.iso100 = "00000000000"
      msg.iso102 = "505000209047           "
      msg.iso116 = "05000810"

      msg.iso002.should eq "434971******1380"
      msg.iso049.should eq "978"
      msg.iso102.should eq "505000209047           "
    end
  end

  describe "validate!" do
    it "raises when required fields are missing" do
      expect_raises(CrystalIso8583::Shared::BuildError) do
        CrystalIso8583::V1993::Msg1100.new.validate!
      end
    end

    it "passes when iso002, iso003, iso004 are set" do
      msg = CrystalIso8583::V1993::Msg1100.new
      msg.iso002 = "4111111111111111"
      msg.iso003 = "000000"
      msg.iso004 = "000000000100"
      msg.validate!
    end
  end

  describe "field_meta isolation" do
    it "does not share FIELD_META with Msg1110" do
      m1100_ids = CrystalIso8583::V1993::Msg1100.new.field_meta.keys.sort
      m1110_ids = CrystalIso8583::V1993::Msg1110.new.field_meta.keys.sort
      m1100_ids.should_not eq m1110_ids
    end
  end
end
