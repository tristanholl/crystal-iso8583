require "../spec_helper"

describe CrystalISO8583::Shared::Parser do
  it "writes a trace line per MTI/bitmap/field when debug is enabled" do
    dict = CrystalISO8583::V1993::DataDictionary.fields
    codec = CrystalISO8583::Shared::Codec::ASCII.new
    builder = CrystalISO8583::Shared::Builder.new(dict, codec)

    fvs = {3 => CrystalISO8583::Shared::FieldValue.new(Bytes.new(0), "310000")}
    message = CrystalISO8583::Shared::Message.new(
      mti: CrystalISO8583::Shared::MTI.parse("1100"),
      bitmap: CrystalISO8583::Shared::Bitmap.new,
      fields: fvs
    )
    bytes = builder.build(message)

    log = IO::Memory.new
    parser = CrystalISO8583::Shared::Parser.new(dict, codec, debug: true, log: log)
    parser.parse(bytes)

    output = log.to_s
    output.should contain "MTI"
    output.should contain "decoded=1100"
    output.should contain "BITMAP"
    output.should contain "F3 (Processing Code)"
    output.should contain "decoded=\"310000\""
  end

  it "does not write to the log when debug is disabled" do
    dict = CrystalISO8583::V1993::DataDictionary.fields
    codec = CrystalISO8583::Shared::Codec::ASCII.new
    builder = CrystalISO8583::Shared::Builder.new(dict, codec)

    fvs = {3 => CrystalISO8583::Shared::FieldValue.new(Bytes.new(0), "310000")}
    message = CrystalISO8583::Shared::Message.new(
      mti: CrystalISO8583::Shared::MTI.parse("1100"),
      bitmap: CrystalISO8583::Shared::Bitmap.new,
      fields: fvs
    )
    bytes = builder.build(message)

    log = IO::Memory.new
    parser = CrystalISO8583::Shared::Parser.new(dict, codec, log: log)
    parser.parse(bytes)

    log.to_s.should be_empty
  end
end
