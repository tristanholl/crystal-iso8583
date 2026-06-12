require "../spec_helper"

describe ISO8583::V1993::Parser do
  describe ".parse" do
    it "returns an AuthRequest for MTI 1100" do
      msg = ISO8583::V1993::Parser.parse(SAMPLE_1100)
      msg.should be_a(ISO8583::V1993::Messages::AuthRequest)
    end

    it "decodes the MTI as ASCII" do
      msg = ISO8583::V1993::Parser.parse(SAMPLE_1100)
      msg.mti.to_s.should eq "1100"
      msg.mti.version.should eq 1
    end

    it "decodes DE 2 (PAN)" do
      msg = ISO8583::V1993::Parser.parse(SAMPLE_1100).as(ISO8583::V1993::Messages::AuthRequest)
      msg.pan.should eq "4111111111111111"
    end

    it "decodes DE 4 (Amount)" do
      msg = ISO8583::V1993::Parser.parse(SAMPLE_1100)
      msg.field_value(4).should eq "000000001000"
    end
  end

  describe "round-trip with Serializer" do
    it "serializes and re-parses a 1993 message" do
      original = ISO8583::V1993::Messages::AuthRequest.build(
        pan: "5500005555555559",
        processing_code: "000000",
        amount: "000000002500",
        stan: "000042",
        terminal_id: "TERM0001",
      )
      bytes = ISO8583::V1993::Serializer.serialize(original)

      # MTI must be 4 ASCII bytes
      String.new(bytes[0, 4]).should eq "1100"

      parsed = ISO8583::V1993::Parser.parse(bytes).as(ISO8583::V1993::Messages::AuthRequest)
      parsed.pan.should eq "5500005555555559"
      parsed.amount.should eq "000000002500"
      parsed.stan.should eq "000042"
      parsed.terminal_id.should eq "TERM0001"
    end
  end
end
