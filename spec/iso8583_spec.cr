require "./spec_helper"

describe CrystalIso8583 do
  describe CrystalIso8583::Bitmap do
    it "tracks present fields" do
      bitmap = CrystalIso8583::Bitmap.new
      bitmap.set(2)
      bitmap.present?(2).should be_true
      bitmap.present?(3).should be_false
    end

    it "enables secondary bitmap for fields > 64" do
      bitmap = CrystalIso8583::Bitmap.new
      bitmap.set(65)
      bitmap.has_secondary?.should be_true
    end
  end

  describe CrystalIso8583::Message do
    it "encodes MTI and bitmap" do
      msg = CrystalIso8583::Message.new("0200")
      msg.encode.should start_with("0200")
    end
  end
end
