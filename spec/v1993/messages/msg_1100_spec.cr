require "../../spec_helper"

describe CrystalISO8583::V1993::Msg1100 do
  describe "mti_string" do
    it "is 1100" do
      CrystalISO8583::V1993::Msg1100.new.mti_string.should eq "1100"
    end
  end

  describe "validate!" do
    it "raises when required fields are missing" do
      expect_raises(CrystalISO8583::Shared::BuildError) do
        CrystalISO8583::V1993::Msg1100.new.validate!
      end
    end

    it "passes when all mandatory fields are set" do
      msg = CrystalISO8583::V1993::Msg1100.new
      msg.iso002 = "4111111111111111"
      msg.iso003 = "000000"
      msg.iso007 = "0618120000"
      msg.iso011 = "000001"
      msg.iso012 = "260618120000"
      msg.iso022 = "51000000000 "
      msg.iso024 = "100"
      msg.iso026 = "5411"
      msg.iso032 = "27200"
      msg.iso037 = "000000000001"
      msg.iso041 = "TERM0001"
      msg.iso042 = "MERCH001       "
      msg.iso043 = "MyShop\\Berlin\\10115\\DE"
      msg.iso048 = "001EAPS"
      msg.validate!
    end
  end

  describe "field_meta isolation" do
    it "does not share FIELD_META with Msg1110" do
      m1100_ids = CrystalISO8583::V1993::Msg1100.new.field_meta.keys.sort
      m1110_ids = CrystalISO8583::V1993::Msg1110.new.field_meta.keys.sort
      m1100_ids.should_not eq m1110_ids
    end
  end
end
