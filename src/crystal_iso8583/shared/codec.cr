module CrystalIso8583
  module Shared
    module Codec
      abstract def encode_mti(mti : MTI) : Bytes
      abstract def decode_mti(bytes : Bytes) : MTI
      abstract def encode_length(length : Int32, digits : Int32) : Bytes
      abstract def decode_length(bytes : Bytes, digits : Int32) : Int32
      abstract def encode_string(str : String) : Bytes
      abstract def decode_string(bytes : Bytes) : String

      # Number of bytes used by the MTI in this codec.
      abstract def mti_byte_size : Int32

      # Number of bytes used by a variable-length prefix with `digits` digit positions.
      abstract def length_byte_size(digits : Int32) : Int32

      # Number of wire bytes occupied by `length` field-units of `data_type`.
      abstract def field_byte_size(length : Int32, data_type : DataType) : Int32

      # Encode a field value string using the codec rules for the given data type.
      abstract def encode_field(str : String, data_type : DataType) : Bytes

      # Decode raw field bytes into a typed value.
      # `length` is the logical field length (number of characters/digits), not the byte count.
      abstract def decode_field(bytes : Bytes, data_type : DataType, length : Int32) : String | Int64 | Bytes

      # -----------------------------------------------------------------------
      # ASCII codec — all data as printable ASCII characters.
      # -----------------------------------------------------------------------
      class ASCII
        include Codec

        def mti_byte_size : Int32
          4
        end

        def length_byte_size(digits : Int32) : Int32
          digits
        end

        def field_byte_size(length : Int32, data_type : DataType) : Int32
          length
        end

        def encode_mti(mti : MTI) : Bytes
          mti.to_s.to_slice
        end

        def decode_mti(bytes : Bytes) : MTI
          MTI.parse(String.new(bytes[0, 4]))
        end

        def encode_length(length : Int32, digits : Int32) : Bytes
          length.to_s.rjust(digits, '0').to_slice
        end

        def decode_length(bytes : Bytes, digits : Int32) : Int32
          String.new(bytes[0, digits]).to_i
        end

        def encode_string(str : String) : Bytes
          str.to_slice
        end

        def decode_string(bytes : Bytes) : String
          String.new(bytes)
        end

        def encode_field(str : String, data_type : DataType) : Bytes
          str.to_slice
        end

        def decode_field(bytes : Bytes, data_type : DataType, length : Int32) : String | Int64 | Bytes
          case data_type
          when DataType::B
            bytes.dup
          when DataType::N
            s = String.new(bytes)
            s.to_i64? || s
          else
            String.new(bytes)
          end
        end
      end

      # -----------------------------------------------------------------------
      # BCD codec — MTI and numeric fields as packed Binary Coded Decimal;
      # alphanumeric/binary fields remain as raw ASCII bytes.
      # -----------------------------------------------------------------------
      class BCD
        include Codec

        def mti_byte_size : Int32
          2
        end

        def length_byte_size(digits : Int32) : Int32
          # 2 digit positions → 1 byte; 3 digit positions → 2 bytes (left-padded nibble)
          (digits + 1) // 2
        end

        def field_byte_size(length : Int32, data_type : DataType) : Int32
          data_type == DataType::N ? (length + 1) // 2 : length
        end

        def encode_mti(mti : MTI) : Bytes
          pack_bcd(mti.to_s)
        end

        def decode_mti(bytes : Bytes) : MTI
          MTI.parse(unpack_bcd(bytes[0, 2]))
        end

        def encode_length(length : Int32, digits : Int32) : Bytes
          pack_bcd(length.to_s.rjust(digits + (digits % 2), '0'))
        end

        def decode_length(bytes : Bytes, digits : Int32) : Int32
          byte_count = (digits + 1) // 2
          full = unpack_bcd(bytes[0, byte_count])
          # For an odd digit count (e.g., 3) we packed into 2 bytes (4 nibbles),
          # so we take only the rightmost `digits` characters.
          full[full.size - digits, digits].to_i
        end

        def encode_string(str : String) : Bytes
          pack_bcd(str)
        end

        def decode_string(bytes : Bytes) : String
          unpack_bcd(bytes)
        end

        def encode_field(str : String, data_type : DataType) : Bytes
          data_type == DataType::N ? pack_bcd(str) : str.to_slice
        end

        def decode_field(bytes : Bytes, data_type : DataType, length : Int32) : String | Int64 | Bytes
          case data_type
          when DataType::B
            bytes.dup
          when DataType::N
            # Unpack and trim to `length` digits (packed form may have a leading zero nibble).
            unpacked = unpack_bcd(bytes)
            s = unpacked.size > length ? unpacked[unpacked.size - length, length] : unpacked
            s.to_i64? || s
          else
            String.new(bytes[0, length])
          end
        end

        private def pack_bcd(digits : String) : Bytes
          padded = digits.size.odd? ? "0" + digits : digits
          Bytes.new(padded.size // 2) { |i| (((padded[i * 2] - '0') << 4) | (padded[i * 2 + 1] - '0')).to_u8 }
        end

        private def unpack_bcd(bytes : Bytes) : String
          String.build(bytes.size * 2) do |sb|
            bytes.each do |b|
              sb << ((b >> 4) & 0x0F)
              sb << (b & 0x0F)
            end
          end
        end
      end

      # -----------------------------------------------------------------------
      # EBCDIC codec — all printable data encoded in IBM EBCDIC Code Page 037.
      # -----------------------------------------------------------------------
      class EBCDIC
        include Codec

        def mti_byte_size : Int32
          4
        end

        def length_byte_size(digits : Int32) : Int32
          digits
        end

        def field_byte_size(length : Int32, data_type : DataType) : Int32
          length
        end

        def encode_mti(mti : MTI) : Bytes
          encode_string(mti.to_s)
        end

        def decode_mti(bytes : Bytes) : MTI
          MTI.parse(decode_string(bytes[0, 4]))
        end

        def encode_length(length : Int32, digits : Int32) : Bytes
          encode_string(length.to_s.rjust(digits, '0'))
        end

        def decode_length(bytes : Bytes, digits : Int32) : Int32
          decode_string(bytes[0, digits]).to_i
        end

        def encode_string(str : String) : Bytes
          slice = str.to_slice
          Bytes.new(str.bytesize) { |i| Shared::EBCDIC::TO_EBCDIC[slice[i]] }
        end

        def decode_string(bytes : Bytes) : String
          String.new(Bytes.new(bytes.size) { |i| Shared::EBCDIC::TO_ASCII[bytes[i]] })
        end

        def encode_field(str : String, data_type : DataType) : Bytes
          data_type == DataType::B ? str.to_slice : encode_string(str)
        end

        def decode_field(bytes : Bytes, data_type : DataType, length : Int32) : String | Int64 | Bytes
          case data_type
          when DataType::B
            bytes.dup
          when DataType::N
            s = decode_string(bytes)
            s.to_i64? || s
          else
            decode_string(bytes)
          end
        end
      end
    end
  end
end
