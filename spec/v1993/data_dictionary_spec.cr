require "../spec_helper"

describe CrystalIso8583::V1993::DataDictionary do
  fields = CrystalIso8583::V1993::DataDictionary.fields

  describe "BMP 39 - Action Code" do
    it "is FIXED n3" do
      f = fields[39]
      f.encoding.should eq CrystalIso8583::Shared::FieldEncoding::FIXED
      f.max_length.should eq 3
      f.data_type.should eq CrystalIso8583::Shared::DataType::N
      f.label.should eq "Action Code"
    end
  end

  describe "BMP 43 - Card Acceptor Name/Location" do
    it "is LLVAR ans..56" do
      f = fields[43]
      f.encoding.should eq CrystalIso8583::Shared::FieldEncoding::LLVAR
      f.max_length.should eq 56
    end
  end

  describe "BMP 53 - Security Related Control Information" do
    it "is LLVAR b..48" do
      f = fields[53]
      f.encoding.should eq CrystalIso8583::Shared::FieldEncoding::LLVAR
      f.max_length.should eq 48
      f.data_type.should eq CrystalIso8583::Shared::DataType::B
    end
  end

  describe "BMP 55 - ICC Data" do
    it "is LLLVAR b..255" do
      f = fields[55]
      f.encoding.should eq CrystalIso8583::Shared::FieldEncoding::LLLVAR
      f.max_length.should eq 255
      f.data_type.should eq CrystalIso8583::Shared::DataType::B
    end
  end

  describe "BMP 56 - Original Data Elements" do
    it "is LLVAR n..35" do
      f = fields[56]
      f.encoding.should eq CrystalIso8583::Shared::FieldEncoding::LLVAR
      f.max_length.should eq 35
      f.data_type.should eq CrystalIso8583::Shared::DataType::N
      f.label.should eq "Original Data Elements"
    end
  end

  describe "BMP 25 - Message Reason Code" do
    it "is FIXED n4" do
      f = fields[25]
      f.encoding.should eq CrystalIso8583::Shared::FieldEncoding::FIXED
      f.max_length.should eq 4
      f.label.should eq "Message Reason Code"
    end
  end

  describe "BMP 30 - Amounts, Original" do
    it "is FIXED n24" do
      f = fields[30]
      f.encoding.should eq CrystalIso8583::Shared::FieldEncoding::FIXED
      f.max_length.should eq 24
      f.data_type.should eq CrystalIso8583::Shared::DataType::N
      f.label.should eq "Amounts, Original"
    end
  end

  describe "BMP 95 - Card Issuer Reference Data" do
    it "is LLVAR ans..99" do
      f = fields[95]
      f.encoding.should eq CrystalIso8583::Shared::FieldEncoding::LLVAR
      f.max_length.should eq 99
      f.label.should eq "Card Issuer Reference Data"
    end
  end

  describe "BMP 111 - Encryption Data" do
    it "is LLLLVAR b..9999" do
      f = fields[111]
      f.encoding.should eq CrystalIso8583::Shared::FieldEncoding::LLLLVAR
      f.max_length.should eq 9999
      f.data_type.should eq CrystalIso8583::Shared::DataType::B
      f.label.should eq "Encryption Data"
    end
  end

  describe "removed fields" do
    it "does not contain BMP 90 (was wrong Original Data Elements)" do
      fields.has_key?(90).should be_false
    end

    it "does not contain BMP 18 (Merchant Type, not in spec)" do
      fields.has_key?(18).should be_false
    end

    it "does not contain BMP 33 (Forwarding Institution ID, not in spec)" do
      fields.has_key?(33).should be_false
    end
  end
end
