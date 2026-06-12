require "../spec_helper"

describe ISO8583::Shared::MTI do
  describe ".from_string" do
    it "parses all four digits" do
      mti = ISO8583::Shared::MTI.from_string("0100")
      mti.version.should eq 0
      mti.msg_class.should eq 1
      mti.function.should eq 0
      mti.originator.should eq 0
      mti.to_s.should eq "0100"
    end

    it "raises on wrong length" do
      expect_raises(ArgumentError) { ISO8583::Shared::MTI.from_string("010") }
    end
  end

  describe ".from_bcd / to_bcd" do
    it "round-trips 1987-style BCD encoding" do
      %w[0100 0110 0120 0130].each do |mti_str|
        mti = ISO8583::Shared::MTI.from_string(mti_str)
        bcd = mti.to_bcd
        bcd.size.should eq 2
        ISO8583::Shared::MTI.from_bcd(bcd).to_s.should eq mti_str
      end
    end
  end

  describe ".from_ascii / to_ascii" do
    it "round-trips 1993-style ASCII encoding" do
      %w[1100 1110 1120 1130].each do |mti_str|
        mti = ISO8583::Shared::MTI.from_string(mti_str)
        ascii = mti.to_ascii
        ascii.size.should eq 4
        String.new(ascii).should eq mti_str
        ISO8583::Shared::MTI.from_ascii(ascii).to_s.should eq mti_str
      end
    end
  end
end
