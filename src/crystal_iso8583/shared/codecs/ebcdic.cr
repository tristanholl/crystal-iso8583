module CrystalIso8583
  module Shared
    module Codec
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
          data_type == DataType::B ? str.hexbytes : encode_string(str)
        end

        def decode_field(bytes : Bytes, data_type : DataType, length : Int32) : String
          case data_type
          when DataType::B then bytes.hexstring
          else                  decode_string(bytes)
          end
        end
      end
    end
  end
end
