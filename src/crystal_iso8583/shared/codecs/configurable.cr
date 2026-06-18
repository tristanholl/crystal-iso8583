module CrystalIso8583
  module Shared
    module Codec
      # -----------------------------------------------------------------------
      # Configurable codec — independently selects the wire encoding used for
      # the MTI, variable-length prefixes, numeric (N) field data, and
      # alphanumeric (AN/ANS/Z) field data. Useful for real-world networks
      # (e.g. VisaNet BASE I) that mix encodings: BCD-packed MTI and numeric
      # fields, raw binary length prefixes, and EBCDIC text fields.
      #
      # Binary (B) field data is always treated as raw bytes, matching the
      # other codecs. Binary length prefixes use a fixed byte width
      # (`binary_length_byte_size`, default 1) for both LLVAR and LLLVAR
      # fields, since real networks typically use a single byte for both
      # rather than scaling the prefix width with the nominal digit count.
      # -----------------------------------------------------------------------
      class Configurable
        include Codec

        def initialize(
          @mti_encoding : SubEncoding = SubEncoding::ASCII,
          @length_encoding : SubEncoding = SubEncoding::ASCII,
          @numeric_encoding : SubEncoding = SubEncoding::ASCII,
          @text_encoding : SubEncoding = SubEncoding::ASCII,
          @binary_length_byte_size : Int32 = 1,
        )
          unless {SubEncoding::ASCII, SubEncoding::BCD, SubEncoding::EBCDIC}.includes?(@mti_encoding)
            raise ArgumentError.new("mti_encoding must be ASCII, BCD, or EBCDIC, got #{@mti_encoding}")
          end
          unless {SubEncoding::ASCII, SubEncoding::BCD, SubEncoding::EBCDIC}.includes?(@numeric_encoding)
            raise ArgumentError.new("numeric_encoding must be ASCII, BCD, or EBCDIC, got #{@numeric_encoding}")
          end
          unless {SubEncoding::ASCII, SubEncoding::EBCDIC}.includes?(@text_encoding)
            raise ArgumentError.new("text_encoding must be ASCII or EBCDIC, got #{@text_encoding}")
          end
        end

        def mti_byte_size : Int32
          @mti_encoding == SubEncoding::BCD ? 2 : 4
        end

        def length_byte_size(digits : Int32) : Int32
          case @length_encoding
          when SubEncoding::BCD    then (digits + 1) // 2
          when SubEncoding::Binary then @binary_length_byte_size
          else                          digits
          end
        end

        def field_byte_size(length : Int32, data_type : DataType) : Int32
          if data_type == DataType::N && @numeric_encoding == SubEncoding::BCD
            (length + 1) // 2
          else
            length
          end
        end

        def encode_mti(mti : MTI) : Bytes
          case @mti_encoding
          when SubEncoding::BCD    then BCDUtil.pack(mti.to_s)
          when SubEncoding::EBCDIC then ebcdic_encode(mti.to_s)
          else                          mti.to_s.to_slice
          end
        end

        def decode_mti(bytes : Bytes) : MTI
          str = case @mti_encoding
                when SubEncoding::BCD    then BCDUtil.unpack(bytes[0, 2])
                when SubEncoding::EBCDIC then ebcdic_decode(bytes[0, 4])
                else                          String.new(bytes[0, 4])
                end
          MTI.parse(str)
        end

        def encode_length(length : Int32, digits : Int32) : Bytes
          case @length_encoding
          when SubEncoding::BCD
            BCDUtil.pack(length.to_s.rjust(digits + (digits % 2), '0'))
          when SubEncoding::EBCDIC
            ebcdic_encode(length.to_s.rjust(digits, '0'))
          when SubEncoding::Binary
            byte_size = length_byte_size(digits)
            Bytes.new(byte_size) { |i| ((length >> (8 * (byte_size - 1 - i))) & 0xFF).to_u8 }
          else
            length.to_s.rjust(digits, '0').to_slice
          end
        end

        def decode_length(bytes : Bytes, digits : Int32) : Int32
          case @length_encoding
          when SubEncoding::BCD
            byte_count = (digits + 1) // 2
            full = BCDUtil.unpack(bytes[0, byte_count])
            full[full.size - digits, digits].to_i
          when SubEncoding::EBCDIC
            ebcdic_decode(bytes[0, digits]).to_i
          when SubEncoding::Binary
            byte_size = length_byte_size(digits)
            bytes[0, byte_size].reduce(0) { |acc, b| (acc << 8) | b }
          else
            String.new(bytes[0, digits]).to_i
          end
        end

        def encode_string(str : String) : Bytes
          @text_encoding == SubEncoding::EBCDIC ? ebcdic_encode(str) : str.to_slice
        end

        def decode_string(bytes : Bytes) : String
          @text_encoding == SubEncoding::EBCDIC ? ebcdic_decode(bytes) : String.new(bytes)
        end

        def encode_field(str : String, data_type : DataType) : Bytes
          if data_type == DataType::B
            str.to_slice
          elsif data_type == DataType::N
            case @numeric_encoding
            when SubEncoding::BCD    then BCDUtil.pack(str)
            when SubEncoding::EBCDIC then ebcdic_encode(str)
            else                          str.to_slice
            end
          else
            @text_encoding == SubEncoding::EBCDIC ? ebcdic_encode(str) : str.to_slice
          end
        end

        def decode_field(bytes : Bytes, data_type : DataType, length : Int32) : String
          case data_type
          when DataType::B
            bytes.hexstring
          when DataType::N
            case @numeric_encoding
            when SubEncoding::BCD
              unpacked = BCDUtil.unpack(bytes)
              unpacked.size > length ? unpacked[unpacked.size - length, length] : unpacked
            when SubEncoding::EBCDIC
              ebcdic_decode(bytes)
            else
              String.new(bytes)
            end
          else
            @text_encoding == SubEncoding::EBCDIC ? ebcdic_decode(bytes[0, length]) : String.new(bytes[0, length])
          end
        end

        private def ebcdic_encode(str : String) : Bytes
          slice = str.to_slice
          Bytes.new(str.bytesize) { |i| Shared::EBCDIC::TO_EBCDIC[slice[i]] }
        end

        private def ebcdic_decode(bytes : Bytes) : String
          String.new(Bytes.new(bytes.size) { |i| Shared::EBCDIC::TO_ASCII[bytes[i]] })
        end
      end
    end
  end
end
