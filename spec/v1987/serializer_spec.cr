require "../spec_helper"

describe ISO8583::V1987::Serializer do
  describe ".serialize" do
    it "serializes a built message and round-trips through the parser" do
      original = ISO8583::V1987::Messages::AuthRequest.build(
        pan: "4111111111111111",
        processing_code: "000000",
        amount: "000000001000",
        transmission_datetime: "0612153045",
        stan: "000123",
        local_time: "153045",
        local_date: "0612",
        expiry: "2512",
      )

      bytes = ISO8583::V1987::Serializer.serialize(original)
      parsed = ISO8583::V1987::Parser.parse(bytes).as(ISO8583::V1987::Messages::AuthRequest)

      parsed.mti.to_s.should eq "0100"
      parsed.pan.should eq "4111111111111111"
      parsed.processing_code.should eq "000000"
      parsed.amount.should eq "000000001000"
      parsed.stan.should eq "000123"
      parsed.expiry.should eq "2512"
    end

    it "serializes the known sample binary correctly" do
      # Re-parse the same hand-crafted binary defined in parser_spec.cr
      msg = ISO8583::V1987::Parser.parse(SAMPLE_0100)
      bytes = ISO8583::V1987::Serializer.serialize(msg.as(ISO8583::V1987::Message))
      bytes.should eq SAMPLE_0100
    end

    it "includes the MTI as 2 BCD bytes" do
      msg = ISO8583::V1987::Messages::AuthRequest.build(
        processing_code: "000000",
        amount: "000000001000",
        stan: "000001",
      )
      bytes = ISO8583::V1987::Serializer.serialize(msg)
      bytes[0].should eq 0x01_u8
      bytes[1].should eq 0x00_u8
    end
  end
end
