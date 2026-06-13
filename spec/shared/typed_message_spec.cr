require "../spec_helper"

private class TestMsg < CrystalIso8583::Shared::TypedMessage
  mti "9999"

  field iso002, id: 2, label: "PAN", required: true
  field iso003, id: 3, label: "Processing Code", required: true
  field iso004, id: 4, label: "Amount"
end

describe CrystalIso8583::Shared::TypedMessage do
  describe "field macro" do
    it "generates a getter that returns nil when unset" do
      msg = TestMsg.new
      msg.iso002.should be_nil
    end

    it "generates a setter that stores the value" do
      msg = TestMsg.new
      msg.iso002 = "4111111111111111"
      msg.iso002.should eq "4111111111111111"
    end

    it "setter returns self for chaining" do
      msg = TestMsg.new
      result = (msg.iso002 = "4111111111111111")
      result.should be_a TestMsg
    end
  end

  describe "subscript access" do
    it "reads an unset field as nil" do
      TestMsg.new[2].should be_nil
    end

    it "reads a set field by id" do
      msg = TestMsg.new
      msg.iso002 = "123"
      msg[2].should eq "123"
    end

    it "writes a field by id" do
      msg = TestMsg.new
      msg[2] = "456"
      msg.iso002.should eq "456"
    end
  end

  describe "field_meta" do
    it "tracks declared fields with their metadata" do
      meta = TestMsg.new.field_meta
      meta[2][:label].should eq "PAN"
      meta[2][:required].should be_true
      meta[4][:label].should eq "Amount"
      meta[4][:required].should be_false
    end

    it "is isolated per class" do
      test_meta = TestMsg.new.field_meta
      msg_meta = CrystalIso8583::V1993::Msg1100.new.field_meta
      test_meta.should_not eq msg_meta
    end
  end

  describe "mti_string" do
    it "returns the declared MTI" do
      TestMsg.new.mti_string.should eq "9999"
    end
  end

  describe "validate!" do
    it "raises BuildError listing missing required fields" do
      msg = TestMsg.new
      expect_raises(CrystalIso8583::Shared::BuildError) do
        msg.validate!
      end
    end

    it "passes when all required fields are set" do
      msg = TestMsg.new
      msg.iso002 = "4111111111111111"
      msg.iso003 = "000000"
      msg.validate!
    end

    it "does not require optional fields" do
      msg = TestMsg.new
      msg.iso002 = "4111111111111111"
      msg.iso003 = "000000"
      msg.iso004.should be_nil
      msg.validate!
    end
  end
end
