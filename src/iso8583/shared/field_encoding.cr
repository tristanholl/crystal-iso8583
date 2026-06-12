module ISO8583
  module Shared
    # The content type of a field value
    enum DataType
      N   # Numeric — BCD packed (2 decimal digits per byte)
      AN  # Alphanumeric — ASCII, space-padded right
      ANS # Alphanumeric + special chars — ASCII, space-padded right
      B   # Binary — raw bytes; lengths are byte counts, not digit counts
      Z   # Track-2 equivalent — nibble-packed like N, may include separator nibbles
    end

    # Whether the field's length in the stream is fixed or prefixed
    enum LengthType
      Fixed   # Exact byte count derived from max_length + data type
      LLVAR   # 1-byte BCD length prefix (00-99 chars/bytes)
      LLLVAR  # 2-byte BCD length prefix encoding "0NNN" (000-999 chars/bytes)
    end

    struct FieldDefinition
      getter number : Int32
      getter name : String
      getter data_type : DataType
      getter length_type : LengthType
      getter max_length : Int32 # in characters/digits (not bytes for BCD types)

      def initialize(@number : Int32, @name : String, @data_type : DataType,
                     @length_type : LengthType, @max_length : Int32)
      end

      def variable_length? : Bool
        length_type != LengthType::Fixed
      end

      # Byte count for this field when stored as fixed-length in the stream
      def fixed_byte_size : Int32
        case data_type
        when DataType::N, DataType::Z then (max_length + 1) // 2
        else                               max_length
        end
      end

      # Byte count for the field value given a known character/digit length
      def byte_size_for(char_length : Int32) : Int32
        case data_type
        when DataType::N, DataType::Z then (char_length + 1) // 2
        else                               char_length
        end
      end
    end

    # Binary Coded Decimal utilities
    module BCD
      # Pack a decimal digit string into BCD bytes.
      # Left zero-pads to an even digit count.
      # "1234" -> [0x12, 0x34], "123" -> [0x01, 0x23]
      def self.encode(digits : String) : Bytes
        padded = digits.size.odd? ? "0#{digits}" : digits
        result = Bytes.new(padded.size // 2)
        result.size.times do |i|
          hi = padded.byte_at(i * 2) - '0'.ord
          lo = padded.byte_at(i * 2 + 1) - '0'.ord
          result[i] = ((hi << 4) | lo).to_u8
        end
        result
      end

      # Unpack BCD bytes into a decimal digit string of exactly num_digits length.
      # [0x12, 0x34], 4 -> "1234", [0x01, 0x23], 3 -> "123"
      def self.decode(bytes : Bytes, num_digits : Int32) : String
        all = String.build do |sb|
          bytes.each do |b|
            sb << ((b >> 4) & 0x0F).to_s
            sb << (b & 0x0F).to_s
          end
        end
        all.size > num_digits ? all[(all.size - num_digits)..] : all
      end
    end

    # Encode/decode field values between string representation and binary stream bytes
    module FieldEncoder
      # Encode a string value to bytes for a fixed-length field
      def self.encode_fixed(value : String, field_def : FieldDefinition) : Bytes
        case field_def.data_type
        when DataType::N
          padded = value.rjust(field_def.max_length, '0')
          padded = "0#{padded}" if padded.size.odd?
          BCD.encode(padded)
        when DataType::Z
          padded = value.size.odd? ? "#{value}F" : value
          BCD.encode(padded)
        when DataType::B
          value.hexbytes
        else # AN, ANS
          result = Bytes.new(field_def.max_length, ' '.ord.to_u8)
          src = value.to_slice
          copy_len = Math.min(src.size, result.size)
          src[0, copy_len].copy_to(result)
          result
        end
      end

      # Encode a string value for a variable-length field.
      # Returns {char_length, data_bytes}; char_length goes into the length prefix.
      def self.encode_variable(value : String, field_def : FieldDefinition) : {Int32, Bytes}
        case field_def.data_type
        when DataType::N
          padded = value.size.odd? ? "0#{value}" : value
          {value.size, BCD.encode(padded)}
        when DataType::Z
          padded = value.size.odd? ? "#{value}F" : value
          {value.size, BCD.encode(padded)}
        when DataType::B
          data = value.hexbytes
          {data.size, data}
        else # AN, ANS
          {value.size, value.to_slice}
        end
      end

      # Decode bytes from a fixed-length field to a string
      def self.decode_fixed(bytes : Bytes, field_def : FieldDefinition) : String
        case field_def.data_type
        when DataType::N, DataType::Z
          BCD.decode(bytes, field_def.max_length)
        when DataType::B
          bytes.hexstring
        else # AN, ANS
          String.new(bytes).rstrip(' ')
        end
      end

      # Decode bytes from a variable-length field to a string given its char/byte length
      def self.decode_variable(bytes : Bytes, char_length : Int32,
                               field_def : FieldDefinition) : String
        case field_def.data_type
        when DataType::N, DataType::Z
          BCD.decode(bytes, char_length)
        when DataType::B
          bytes.hexstring
        else # AN, ANS
          str = String.new(bytes)
          (str.size > char_length ? str[0, char_length] : str).rstrip(' ')
        end
      end
    end
  end
end
