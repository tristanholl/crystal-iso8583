module CrystalISO8583
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

      # Decode raw field bytes into a String.
      # `length` is the logical field length (number of characters/digits), not the byte count.
      # Binary fields (DataType::B) are returned as lowercase hex strings.
      abstract def decode_field(bytes : Bytes, data_type : DataType, length : Int32) : String
    end
  end
end
