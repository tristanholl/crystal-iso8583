require "../src/crystal_iso8583"

module Scheme
  VALID_SCHEMES = ["visa"]

  VISA_VERSION     = "1987"
  VISA_CODEC_NAME  = "configurable"
  VISA_HEADER_SIZE = 22

  def self.build_codec(codec_name : String) : CrystalISO8583::Shared::Codec
    case codec_name
    when "ascii"        then CrystalISO8583::Shared::Codec::ASCII.new
    when "bcd"          then CrystalISO8583::Shared::Codec::BCD.new
    when "ebcdic"       then CrystalISO8583::Shared::Codec::EBCDIC.new
    when "configurable" then visa_configurable_codec
    else
      STDERR.puts "Unknown codec: #{codec_name} (expected ascii, bcd, ebcdic, or configurable)"
      exit 1
    end
  end

  def self.visa_configurable_codec : CrystalISO8583::Shared::Codec::Configurable
    CrystalISO8583::Shared::Codec::Configurable.new(
      mti_encoding: CrystalISO8583::MtiEncoding::BCD,
      length_encoding: CrystalISO8583::LengthEncoding::Binary,
      numeric_encoding: CrystalISO8583::NumericEncoding::BCD,
      text_encoding: CrystalISO8583::TextEncoding::EBCDIC,
    )
  end

  record Resolved,
    version : String,
    codec_name : String,
    codec : CrystalISO8583::Shared::Codec,
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
