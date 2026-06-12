require "../spec_helper"

describe ISO8583::V1987::Parser do
  describe ".parse" do
    it "returns an AuthRequest for MTI 0100" do
      msg = ISO8583::V1987::Parser.parse(SAMPLE_0100)
      msg.should be_a(ISO8583::V1987::Messages::AuthRequest)
    end

    it "decodes the MTI correctly" do
      msg = ISO8583::V1987::Parser.parse(SAMPLE_0100)
      msg.mti.to_s.should eq "0100"
    end

    it "decodes DE 2 (PAN, LLVAR N)" do
      msg = ISO8583::V1987::Parser.parse(SAMPLE_0100).as(ISO8583::V1987::Messages::AuthRequest)
      msg.pan.should eq "4111111111111111"
    end

    it "decodes DE 3 (Processing Code, N 6)" do
      msg = ISO8583::V1987::Parser.parse(SAMPLE_0100)
      msg.field_value(3).should eq "000000"
    end

    it "decodes DE 4 (Amount, N 12)" do
      msg = ISO8583::V1987::Parser.parse(SAMPLE_0100)
      msg.field_value(4).should eq "000000001000"
    end

    it "decodes DE 7 (Transmission Date/Time, N 10)" do
      msg = ISO8583::V1987::Parser.parse(SAMPLE_0100)
      msg.field_value(7).should eq "0612153045"
    end

    it "decodes DE 11 (STAN, N 6)" do
      msg = ISO8583::V1987::Parser.parse(SAMPLE_0100)
      msg.field_value(11).should eq "000123"
    end

    it "decodes DE 14 (Expiry, N 4)" do
      msg = ISO8583::V1987::Parser.parse(SAMPLE_0100)
      msg.field_value(14).should eq "2512"
    end
  end
end
