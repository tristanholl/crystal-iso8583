require "../spec_helper"

describe ISO8583::Shared::BCD do
  describe ".encode" do
    it "encodes an even-length digit string" do
      ISO8583::Shared::BCD.encode("1234").should eq Bytes[0x12, 0x34]
    end

    it "encodes an odd-length digit string with a leading zero pad" do
      ISO8583::Shared::BCD.encode("123").should eq Bytes[0x01, 0x23]
    end

    it "encodes all-zero string" do
      ISO8583::Shared::BCD.encode("000000").should eq Bytes[0x00, 0x00, 0x00]
    end

    it "encodes a 4-digit MTI" do
      ISO8583::Shared::BCD.encode("0100").should eq Bytes[0x01, 0x00]
      ISO8583::Shared::BCD.encode("0110").should eq Bytes[0x01, 0x10]
    end
  end

  describe ".decode" do
    it "decodes to even-length digit string" do
      ISO8583::Shared::BCD.decode(Bytes[0x12, 0x34], 4).should eq "1234"
    end

    it "strips leading pad digit for odd num_digits" do
      ISO8583::Shared::BCD.decode(Bytes[0x01, 0x23], 3).should eq "123"
    end

    it "round-trips encode/decode" do
      %w[0100 0110 0120 0130 123456 000000001000].each do |digits|
        padded_len = digits.size + (digits.size.odd? ? 1 : 0)
        encoded = ISO8583::Shared::BCD.encode(digits)
        ISO8583::Shared::BCD.decode(encoded, digits.size).should eq digits
      end
    end
  end
end
