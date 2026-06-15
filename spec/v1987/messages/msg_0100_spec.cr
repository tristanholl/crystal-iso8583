require "../../spec_helper"

describe CrystalIso8583::V1987::Msg0100 do
  describe "mti_string" do
    it "is 0100" do
      CrystalIso8583::V1987::Msg0100.new.mti_string.should eq "0100"
    end
  end

  describe "field accessors" do
    it "sets and gets PAN" do
      msg = CrystalIso8583::V1987::Msg0100.new
      msg.iso002 = "4111111111111111"
      msg.iso002.should eq "4111111111111111"
    end

    it "sets and gets all required fields" do
      msg = CrystalIso8583::V1987::Msg0100.new
      msg.iso002 = "4111111111111111"
      msg.iso003 = "000000"
      msg.iso004 = "000000001000"
      msg.iso007 = "0615120000"
      msg.iso011 = "000001"
      msg.iso012 = "120000"
      msg.iso013 = "0615"
      msg.iso022 = "051"
      msg.iso025 = "00"
      msg.iso041 = "TERM0001"
      msg.iso042 = "MERCH001       "
      msg.iso049 = "840"

      msg.iso002.should eq "4111111111111111"
      msg.iso003.should eq "000000"
      msg.iso004.should eq "000000001000"
      msg.iso007.should eq "0615120000"
      msg.iso011.should eq "000001"
      msg.iso012.should eq "120000"
      msg.iso013.should eq "0615"
      msg.iso022.should eq "051"
      msg.iso025.should eq "00"
      msg.iso041.should eq "TERM0001"
      msg.iso042.should eq "MERCH001       "
      msg.iso049.should eq "840"
    end
  end

  describe "validate!" do
    it "raises when required fields are missing" do
      expect_raises(CrystalIso8583::Shared::BuildError) do
        CrystalIso8583::V1987::Msg0100.new.validate!
      end
    end

    it "passes when all mandatory fields are set" do
      msg = CrystalIso8583::V1987::Msg0100.new
      msg.iso002 = "4111111111111111"
      msg.iso003 = "000000"
      msg.iso004 = "000000001000"
      msg.iso007 = "0615120000"
      msg.iso011 = "000001"
      msg.iso012 = "120000"
      msg.iso013 = "0615"
      msg.iso022 = "051"
      msg.iso025 = "00"
      msg.iso041 = "TERM0001"
      msg.iso042 = "MERCH001       "
      msg.iso049 = "840"
      msg.validate!
    end
  end

  describe "build and parse round-trip" do
    it "round-trips with ASCII codec" do
      msg = CrystalIso8583::V1987::Msg0100.new
      msg.iso002 = "4111111111111111"
      msg.iso003 = "000000"
      msg.iso004 = "000000001000"
      msg.iso007 = "0615120000"
      msg.iso011 = "000001"
      msg.iso012 = "120000"
      msg.iso013 = "0615"
      msg.iso022 = "051"
      msg.iso025 = "00"
      msg.iso041 = "TERM0001"
      msg.iso042 = "MERCH001       "
      msg.iso049 = "840"
      msg.iso043 = "MyShop          Berlin          DE"

      codec = CrystalIso8583::Shared::Codec::ASCII.new
      bytes = msg.build(codec)
      parsed = CrystalIso8583::V1987::Msg0100.parse(bytes, codec)

      parsed.iso002.should eq "4111111111111111"
      parsed.iso003.should eq "000000"
      parsed.iso004.should eq "000000001000"
      parsed.iso011.should eq "000001"
      parsed.iso012.should eq "120000"
      parsed.iso013.should eq "0615"
      parsed.iso022.should eq "051"
      parsed.iso025.should eq "00"
      parsed.iso041.should eq "TERM0001"
      parsed.iso042.should eq "MERCH001       "
      parsed.iso049.should eq "840"
    end

    it "round-trips with EBCDIC codec" do
      msg = CrystalIso8583::V1987::Msg0100.new
      msg.iso002 = "4111111111111111"
      msg.iso003 = "000000"
      msg.iso004 = "000000001000"
      msg.iso007 = "0615120000"
      msg.iso011 = "000001"
      msg.iso012 = "120000"
      msg.iso013 = "0615"
      msg.iso022 = "051"
      msg.iso025 = "00"
      msg.iso041 = "TERM0001"
      msg.iso042 = "MERCH001       "
      msg.iso049 = "840"

      codec = CrystalIso8583::Shared::Codec::EBCDIC.new
      bytes = msg.build(codec)
      parsed = CrystalIso8583::V1987::Msg0100.parse(bytes, codec)

      parsed.iso002.should eq "4111111111111111"
      parsed.iso003.should eq "000000"
      parsed.iso004.should eq "000000001000"
      parsed.iso041.should eq "TERM0001"
      parsed.iso049.should eq "840"
    end
  end

  describe "field_meta isolation" do
    it "does not share FIELD_META with V1993::Msg1100" do
      v1987_ids = CrystalIso8583::V1987::Msg0100.new.field_meta.keys.sort
      v1993_ids = CrystalIso8583::V1993::Msg1100.new.field_meta.keys.sort
      v1987_ids.should_not eq v1993_ids
    end
  end
end
