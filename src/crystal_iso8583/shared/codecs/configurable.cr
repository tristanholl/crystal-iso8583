module CrystalIso8583
  module Shared
    module Codec
      # -----------------------------------------------------------------------
      # Configurable codec — independently selects the wire encoding used for
      # the MTI, variable-length prefixes, numeric (N) field data, and
      # alphanumeric (AN/ANS) field data. Useful for real-world networks
      # (e.g. VisaNet BASE I) that mix encodings: BCD-packed MTI and numeric
      # fields, raw binary length prefixes, and EBCDIC text fields.
      #
      # Binary (B) field data is always treated as raw bytes, matching the
      # other codecs. Binary length prefixes use a fixed byte width
      # (`binary_length_byte_size`, default 1) for both LLVAR and LLLVAR
      # fields, since real networks typically use a single byte for both
      # rather than scaling the prefix width with the nominal digit count.
      #
      # Track 2 (Z) field data follows numeric_encoding when it's BCD —
      # packed via the Track 2 nibble mapping (digits, '=' separator, 'F'
      # pad nibble) rather than plain digit BCD — since real networks BCD-pack
      # Track 2 the same way they BCD-pack numeric fields. Otherwise it falls
      # back to text_encoding, same as AN/ANS.
      # -----------------------------------------------------------------------
      class Configurable
        include Codec

        def initialize(
          @mti_encoding : MtiEncoding = MtiEncoding::ASCII,
          @length_encoding : LengthEncoding = LengthEncoding::ASCII,
          @numeric_encoding : NumericEncoding = NumericEncoding::ASCII,
          @text_encoding : TextEncoding = TextEncoding::ASCII,
          @binary_length_byte_size : Int32 = 1,
        )
        end

        def mti_byte_size : Int32
          @mti_encoding == MtiEncoding::BCD ? 2 : 4
        end

        def length_byte_size(digits : Int32) : Int32
          case @length_encoding
          when LengthEncoding::BCD    then (digits + 1) // 2
          when LengthEncoding::Binary then @binary_length_byte_size
          else                             digits
          end
        end

        def field_byte_size(length : Int32, data_type : DataType) : Int32
          if (data_type == DataType::N || data_type == DataType::Z) && @numeric_encoding == NumericEncoding::BCD
            (length + 1) // 2
          else
            length
          end
        end

        def encode_mti(mti : MTI) : Bytes
          case @mti_encoding
          when MtiEncoding::BCD    then BCDUtil.pack(mti.to_s)
          when MtiEncoding::EBCDIC then ebcdic_encode(mti.to_s)
          else                          mti.to_s.to_slice
          end
        end

        def decode_mti(bytes : Bytes) : MTI
          str = case @mti_encoding
                when MtiEncoding::BCD    then BCDUtil.unpack(bytes[0, 2])
                when MtiEncoding::EBCDIC then ebcdic_decode(bytes[0, 4])
                else                          String.new(bytes[0, 4])
                end
          MTI.parse(str)
        end

        def encode_length(length : Int32, digits : Int32) : Bytes
          case @length_encoding
          when LengthEncoding::BCD
            BCDUtil.pack(length.to_s.rjust(digits + (digits % 2), '0'))
          when LengthEncoding::EBCDIC
            ebcdic_encode(length.to_s.rjust(digits, '0'))
          when LengthEncoding::Binary
            byte_size = length_byte_size(digits)
            Bytes.new(byte_size) { |i| ((length >> (8 * (byte_size - 1 - i))) & 0xFF).to_u8 }
          else
            length.to_s.rjust(digits, '0').to_slice
          end
        end

        def decode_length(bytes : Bytes, digits : Int32) : Int32
          case @length_encoding
          when LengthEncoding::BCD
            byte_count = (digits + 1) // 2
            full = BCDUtil.unpack(bytes[0, byte_count])
            full[full.size - digits, digits].to_i
          when LengthEncoding::EBCDIC
            ebcdic_decode(bytes[0, digits]).to_i
          when LengthEncoding::Binary
            byte_size = length_byte_size(digits)
            bytes[0, byte_size].reduce(0) { |acc, b| (acc << 8) | b }
          else
            String.new(bytes[0, digits]).to_i
          end
        end

        def encode_string(str : String) : Bytes
          @text_encoding == TextEncoding::EBCDIC ? ebcdic_encode(str) : str.to_slice
        end

        def decode_string(bytes : Bytes) : String
          @text_encoding == TextEncoding::EBCDIC ? ebcdic_decode(bytes) : String.new(bytes)
        end

        def encode_field(str : String, data_type : DataType) : Bytes
          if data_type == DataType::B
            str.to_slice
          elsif data_type == DataType::N
            case @numeric_encoding
            when NumericEncoding::BCD    then BCDUtil.pack(str)
            when NumericEncoding::EBCDIC then ebcdic_encode(str)
            else                               str.to_slice
            end
          elsif data_type == DataType::Z && @numeric_encoding == NumericEncoding::BCD
            BCDUtil.pack_track2(str)
          else
            @text_encoding == TextEncoding::EBCDIC ? ebcdic_encode(str) : str.to_slice
          end
        end

        def decode_field(bytes : Bytes, data_type : DataType, length : Int32) : String
          case data_type
          when DataType::B
            bytes.hexstring
          when DataType::N
            case @numeric_encoding
            when NumericEncoding::BCD
              unpacked = BCDUtil.unpack(bytes)
              unpacked.size > length ? unpacked[unpacked.size - length, length] : unpacked
            when NumericEncoding::EBCDIC
              ebcdic_decode(bytes)
            else
              String.new(bytes)
            end
          when DataType::Z
            if @numeric_encoding == NumericEncoding::BCD
              unpacked = BCDUtil.unpack_track2(bytes)
              unpacked.size > length ? unpacked[0, length] : unpacked
            else
              @text_encoding == TextEncoding::EBCDIC ? ebcdic_decode(bytes[0, length]) : String.new(bytes[0, length])
            end
          else
            @text_encoding == TextEncoding::EBCDIC ? ebcdic_decode(bytes[0, length]) : String.new(bytes[0, length])
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
