module CrystalIso8583
  module Shared
    # Builds binary ISO 8583 messages from plain field data.
    # Symmetric to Parser: takes a hash of decoded field values, produces wire bytes.
    class Generator
      def initialize(@dictionary : Hash(Int32, FieldDescriptor), @codec : Codec)
      end

      # Generate binary ISO 8583 bytes from an MTI string and field values.
      # `fields` maps field IDs to their decoded string representations;
      # binary fields (DataType::B) must be provided as lowercase hex strings.
      def generate(mti : String, fields : Hash(Int32, String)) : Bytes
        field_values = fields.transform_values { |v| FieldValue.new(Bytes.new(0), v) }
        message = Message.new(
          mti: MTI.parse(mti),
          bitmap: Bitmap.new,
          fields: field_values
        )
        Builder.new(@dictionary, @codec).build(message)
      end
    end
  end
end
