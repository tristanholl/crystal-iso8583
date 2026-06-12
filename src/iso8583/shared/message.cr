module ISO8583
  module Shared
    # Base class for all ISO 8583 messages.
    # Holds the MTI, all parsed data elements, and a reference to the version dictionary.
    # Concrete subclasses (V1987::Message, V1993::Message) provide the dictionary.
    abstract class Message
      getter mti : MTI
      getter data_elements : Hash(Int32, DataElement)

      def initialize(@mti : MTI,
                     @data_elements : Hash(Int32, DataElement) = {} of Int32 => DataElement)
      end

      # The field dictionary for this message version.
      # Returns field_number -> FieldDefinition.
      abstract def dictionary : Hash(Int32, FieldDefinition)

      # Retrieve a data element by field number (returns nil if absent)
      def [](field_num : Int32) : DataElement?
        data_elements[field_num]?
      end

      # Decoded string value for a field, or nil if the field is not present
      def field_value(field_num : Int32) : String?
        data_elements[field_num]?.try(&.value)
      end

      # Set or replace a field by its string value (encodes using the dictionary)
      def set_field(field_num : Int32, value : String) : Nil
        defn = dictionary[field_num]? || raise ArgumentError.new(
          "Field #{field_num} not defined in #{self.class} dictionary")
        data_elements[field_num] = DataElement.from_value(value, defn)
      end

      # Build the bitmap that reflects which fields are currently present
      def bitmap : Bitmap
        Bitmap.build(data_elements.keys)
      end

      def to_s(io : IO) : Nil
        io << "#{self.class}[#{mti}]"
        data_elements.each_value do |de|
          io << "\n  "
          de.to_s(io)
        end
      end
    end
  end
end
