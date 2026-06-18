require "../src/crystal_iso8583"

module Scheme
  VALID_SCHEMES = ["visa"]

  VISA_VERSION     = "1987"
  VISA_CODEC_NAME  = "configurable"
  VISA_HEADER_SIZE = 22

  # The literal 22-byte proprietary network header (TPDU + "PR4" record-type
  # tag) observed on a real Visa BASE I sample, used to reproduce that
  # message byte-for-byte when --scheme visa builds with a header.
  VISA_HEADER_BYTES = Bytes[
    0x16, 0x01, 0x02, 0x01, 0x50, 0x52, 0x34, 0x01, 0x00, 0x00, 0x00, 0x08,
    0x10, 0x00, 0x46, 0x84, 0x40, 0x09, 0x08, 0x03, 0xa2, 0x01,
  ]

  def self.build_codec(codec_name : String) : CrystalIso8583::Shared::Codec
    case codec_name
    when "ascii"        then CrystalIso8583::Shared::Codec::ASCII.new
    when "bcd"          then CrystalIso8583::Shared::Codec::BCD.new
    when "ebcdic"       then CrystalIso8583::Shared::Codec::EBCDIC.new
    when "configurable" then visa_configurable_codec
    else
      STDERR.puts "Unknown codec: #{codec_name} (expected ascii, bcd, ebcdic, or configurable)"
      exit 1
    end
  end

  def self.visa_configurable_codec : CrystalIso8583::Shared::Codec::Configurable
    CrystalIso8583::Shared::Codec::Configurable.new(
      mti_encoding: CrystalIso8583::Shared::Codec::MtiEncoding::BCD,
      length_encoding: CrystalIso8583::Shared::Codec::LengthEncoding::Binary,
      numeric_encoding: CrystalIso8583::Shared::Codec::NumericEncoding::BCD,
      text_encoding: CrystalIso8583::Shared::Codec::TextEncoding::EBCDIC,
    )
  end

  record Resolved,
    version : String,
    codec_name : String,
    codec : CrystalIso8583::Shared::Codec,
    header_size : Int32?

  def self.resolve(
    scheme : String?,
    version : String,
    codec_name : String?,
    header_size : Int32? = nil,
    explicit_version : Bool = false,
    explicit_codec : Bool = false,
    explicit_header_size : Bool = false,
  ) : Resolved
    if scheme
      unless VALID_SCHEMES.includes?(scheme)
        STDERR.puts "Unknown scheme: #{scheme} (expected #{VALID_SCHEMES.join(", ")})"
        exit 1
      end

      if explicit_version && version != VISA_VERSION
        STDERR.puts "--version #{version} conflicts with --scheme visa (requires version #{VISA_VERSION})"
        exit 1
      end
      if explicit_codec && codec_name != VISA_CODEC_NAME
        STDERR.puts "--codec #{codec_name} conflicts with --scheme visa (requires codec #{VISA_CODEC_NAME})"
        exit 1
      end
      if explicit_header_size && header_size != VISA_HEADER_SIZE
        STDERR.puts "--header-size #{header_size} conflicts with --scheme visa (requires header size #{VISA_HEADER_SIZE})"
        exit 1
      end

      Resolved.new(VISA_VERSION, VISA_CODEC_NAME, visa_configurable_codec, VISA_HEADER_SIZE)
    else
      resolved_codec_name = codec_name || (version == "1987" ? "ebcdic" : "ascii")
      Resolved.new(version, resolved_codec_name, build_codec(resolved_codec_name), header_size)
    end
  end
end
