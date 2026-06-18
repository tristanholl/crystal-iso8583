module CrystalIso8583
  module Shared
    module Codec
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
          BCDUtil.pack(mti.to_s)
        end

        def decode_mti(bytes : Bytes) : MTI
          MTI.parse(BCDUtil.unpack(bytes[0, 2]))
        end

        def encode_length(length : Int32, digits : Int32) : Bytes
          BCDUtil.pack(length.to_s.rjust(digits + (digits % 2), '0'))
        end

        def decode_length(bytes : Bytes, digits : Int32) : Int32
          byte_count = (digits + 1) // 2
          full = BCDUtil.unpack(bytes[0, byte_count])
          # For an odd digit count (e.g., 3) we packed into 2 bytes (4 nibbles),
          # so we take only the rightmost `digits` characters.
          full[full.size - digits, digits].to_i
        end

        def encode_string(str : String) : Bytes
          BCDUtil.pack(str)
        end

        def decode_string(bytes : Bytes) : String
          BCDUtil.unpack(bytes)
        end

        def encode_field(str : String, data_type : DataType) : Bytes
          data_type == DataType::N ? BCDUtil.pack(str) : str.to_slice
        end

        def decode_field(bytes : Bytes, data_type : DataType, length : Int32) : String
          case data_type
          when DataType::B
            bytes.hexstring
          when DataType::N
            # Unpack and trim to `length` digits (packed form may have a leading zero nibble).
            unpacked = BCDUtil.unpack(bytes)
            unpacked.size > length ? unpacked[unpacked.size - length, length] : unpacked
          else
            String.new(bytes[0, length])
          end
        end
      end
    end
  end
end
