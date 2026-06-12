module ISO8583
  module Shared
    # A single parsed data element: field number, raw bytes from the stream,
    # the character/byte count declared by the length prefix (for variable fields),
    # and the field's definition from the dictionary.
    class DataElement
      getter field_number : Int32
      getter raw_bytes : Bytes
      getter char_length : Int32
      getter definition : FieldDefinition

      def initialize(@field_number : Int32, @raw_bytes : Bytes,
                     @char_length : Int32, @definition : FieldDefinition)
      end

      # Decoded string value of this element
      def value : String
        if definition.variable_length?
          FieldEncoder.decode_variable(raw_bytes, char_length, definition)
        else
          FieldEncoder.decode_fixed(raw_bytes, definition)
        end
      end

      # Build a DataElement by encoding a string value for a given field definition
      def self.from_value(value : String, definition : FieldDefinition) : DataElement
        if definition.variable_length?
          char_len, raw = FieldEncoder.encode_variable(value, definition)
          new(definition.number, raw, char_len, definition)
        else
          raw = FieldEncoder.encode_fixed(value, definition)
          new(definition.number, raw, definition.max_length, definition)
        end
      end

      def to_s(io : IO) : Nil
        io << "DE#{field_number}(#{definition.name}): #{value}"
      end
    end
  end
end
