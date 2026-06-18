require "../spec_helper"

describe CrystalIso8583::Shared::Header::FixedLength do
  it "strips a fixed number of leading bytes" do
    strategy = CrystalIso8583::Shared::Header::FixedLength.new(3)
    strategy.strip(Bytes[0x01, 0x02, 0x03, 0x41, 0x42]).should eq Bytes[0x41, 0x42]
  end

  it "wraps payload bytes with a zero-filled header" do
    strategy = CrystalIso8583::Shared::Header::FixedLength.new(3)
    strategy.wrap(Bytes[0x41, 0x42]).should eq Bytes[0x00, 0x00, 0x00, 0x41, 0x42]
  end
end

describe CrystalIso8583::Shared::Header::AsciiLengthPrefix do
  it "strips an N-digit ASCII length prefix" do
    strategy = CrystalIso8583::Shared::Header::AsciiLengthPrefix.new(4)
    bytes = "0002AB".to_slice
    strategy.strip(bytes).should eq "AB".to_slice
  end

  it "wraps payload bytes with an ASCII decimal length prefix" do
    strategy = CrystalIso8583::Shared::Header::AsciiLengthPrefix.new(4)
    wrapped = strategy.wrap("AB".to_slice)
    String.new(wrapped).should eq "0002AB"
  end

  it "round-trips strip/wrap" do
    strategy = CrystalIso8583::Shared::Header::AsciiLengthPrefix.new(4)
    payload = "HELLO".to_slice
    strategy.strip(strategy.wrap(payload)).should eq payload
  end
end
