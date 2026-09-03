module CrystalISO8583
  module Shared
    module Codec
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
          data_type == DataType::B ? str.hexbytes : str.to_slice
        end

        def decode_field(bytes : Bytes, data_type : DataType, length : Int32) : String
          case data_type
          when DataType::B then bytes.hexstring
          else                  String.new(bytes)
          end
        end
      end
    end
  end
end
