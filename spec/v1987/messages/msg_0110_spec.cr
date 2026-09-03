require "../../spec_helper"

describe CrystalISO8583::V1987::Msg0110 do
  describe "mti_string" do
    it "is 0110" do
      CrystalISO8583::V1987::Msg0110.new.mti_string.should eq "0110"
    end
  end

  describe "validate!" do
    it "raises when required fields are missing" do
      expect_raises(CrystalISO8583::Shared::BuildError) do
        CrystalISO8583::V1987::Msg0110.new.validate!
      end
    end

    it "passes when all mandatory fields are set" do
      msg = CrystalISO8583::V1987::Msg0110.new
      msg.iso003 = "000000"
      msg.iso004 = "000000001000"
      msg.iso007 = "0615120000"
      msg.iso011 = "000001"
      msg.iso039 = "00"
      msg.iso041 = "TERM0001"
      msg.iso042 = "MERCH001       "
      msg.iso049 = "840"
      msg.validate!
    end
  end

  describe "build and parse round-trip" do
    it "round-trips with ASCII codec" do
      msg = CrystalISO8583::V1987::Msg0110.new
      msg.iso003 = "000000"
      msg.iso004 = "000000001000"
      msg.iso007 = "0615120000"
      msg.iso011 = "000001"
      msg.iso039 = "00"
      msg.iso041 = "TERM0001"
      msg.iso042 = "MERCH001       "
      msg.iso049 = "840"

      codec = CrystalISO8583::Shared::Codec::ASCII.new
      bytes = msg.build(codec)
      parsed = CrystalISO8583::V1987::Msg0110.parse(bytes, codec)

      parsed.iso039.should eq "00"
      parsed.iso041.should eq "TERM0001"
      parsed.iso049.should eq "840"
    end
  end
end
