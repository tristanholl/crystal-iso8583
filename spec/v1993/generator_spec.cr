require "../spec_helper"

describe CrystalIso8583::V1993::Generator do
  describe "#generate with ASCII codec" do
    codec = CrystalIso8583::Shared::Codec::ASCII.new
    generator = CrystalIso8583::V1993::Generator.new(codec)

    it "produces bytes parseable by the typed message layer" do
      fields = {
        2  => "4349710000001380",
        3  => "310000",
        7  => "0618120000",
        11 => "000001",
        12 => "260618120000",
        22 => "021000000000",
        24 => "100",
        26 => "5411",
        32 => "123456",
        37 => "000000000001",
        41 => "TERM0001",
        42 => "MERCHANT000000 ",
        43 => "MY STORE / NEW YORK / US",
        48 => "PRIVATE",
      }
      bytes = generator.generate("1100", fields)
      msg = CrystalIso8583::V1993::Msg1100.parse(bytes, codec)
      msg.iso002.should eq "4349710000001380"
      msg.iso003.should eq "310000"
      msg.iso007.should eq "0618120000"
      msg.iso011.should eq "000001"
      msg.iso037.should eq "000000000001"
    end

    it "round-trips a 1110 response message" do
      fields = {
        7   => "0618120000",
        11  => "000001",
        39  => "000",
        38  => "123456",
        2   => "4349710000001380",
      }
      bytes = generator.generate("1110", fields)
      msg = CrystalIso8583::V1993::Msg1110.parse(bytes, codec)
      msg.iso007.should eq "0618120000"
      msg.iso039.should eq "000"
      msg.iso038.should eq "123456"
      msg.iso002.should eq "4349710000001380"
    end

    it "round-trips a 1804 network management message" do
      fields = {
        11  => "000001",
        12  => "260618120000",
        24  => "801",
        25  => "0500",
        93  => "12345",
        94  => "67890",
        128 => "0102030405060708",
      }
      bytes = generator.generate("1804", fields)
      msg = CrystalIso8583::V1993::Msg1804.parse(bytes, codec)
      msg.iso011.should eq "000001"
      msg.iso024.should eq "801"
    end
  end

  describe "#generate with BCD codec" do
    codec = CrystalIso8583::Shared::Codec::BCD.new
    generator = CrystalIso8583::V1993::Generator.new(codec)

    it "produces bytes parseable by the typed message layer" do
      fields = {
        2  => "4349710000001380",
        3  => "310000",
        7  => "0618120000",
        11 => "000001",
        12 => "260618120000",
        22 => "021000000000",
        24 => "100",
        26 => "5411",
        32 => "123456",
        37 => "000000000001",
        41 => "TERM0001",
        42 => "MERCHANT000000 ",
        43 => "MY STORE / NEW YORK / US",
        48 => "PRIVATE",
      }
      bytes = generator.generate("1100", fields)
      msg = CrystalIso8583::V1993::Msg1100.parse(bytes, codec)
      msg.iso002.should eq "4349710000001380"
      msg.iso003.should eq "310000"
      msg.iso007.should eq "0618120000"
    end
  end
end
