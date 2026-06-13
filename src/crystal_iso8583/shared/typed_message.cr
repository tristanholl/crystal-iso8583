require "json"

module CrystalIso8583
  module Shared
    abstract class TypedMessage
      abstract def mti_string : String

      # Each subclass gets its own FIELD_META hash (field id → required?) and accessor.
      macro inherited
        FIELD_META = {} of Int32 => Bool

        def field_meta : Hash(Int32, Bool)
          FIELD_META
        end
      end

      # Declares the MTI for the concrete message class.
      macro mti(value)
        def mti_string : String
          {{ value }}
        end
      end

      # Generates a typed getter and setter for a single ISO 8583 field.
      # Setter returns `self` so calls can be chained.
      macro field(name, id, *, required = false)
        FIELD_META[{{ id }}] = {{ required }}

        def {{ name.id }} : String?
          @data[{{ id }}]?
        end

        def {{ name.id }}=(value : String) : self
          @data[{{ id }}] = value
          self
        end
      end

      def initialize
        @data = {} of Int32 => String
      end

      # Generic subscript access for fields not declared via the `field` macro.
      def [](field_id : Int32) : String?
        @data[field_id]?
      end

      def []=(field_id : Int32, value : String) : String
        @data[field_id] = value
      end

      def validate! : Nil
        missing = field_meta
          .select { |_, required| required }
          .keys
          .reject { |id| @data.has_key?(id) }
          .map(&.to_s)
        raise BuildError.new("Missing required fields: #{missing.join(", ")}") unless missing.empty?
      end

      def build(codec : Codec, dictionary : Hash(Int32, FieldDescriptor)) : Bytes
        validate!
        fields = @data.transform_values { |v| FieldValue.new(Bytes.new(0), v) }
        Builder.new(dictionary, codec).build(
          Message.new(mti: MTI.parse(mti_string), bitmap: Bitmap.new, fields: fields)
        )
      end

      def self.parse(bytes : Bytes, codec : Codec, dictionary : Hash(Int32, FieldDescriptor))
        message = Parser.new(dictionary, codec).parse(bytes)
        instance = new
        message.fields.each do |id, fv|
          decoded = fv.decoded
          instance.set_raw_field(id, decoded.is_a?(String) ? decoded : decoded.to_s)
        end
        instance
      end

      def to_json : String
        JSON.build do |json|
          json.object do
            json.field "mti", mti_string
            json.field "fields" do
              json.object do
                @data.each do |id, value|
                  json.field id.to_s do
                    json.object do
                      json.field "label", field_label(id)
                      json.field "value", value
                    end
                  end
                end
              end
            end
          end
        end
      end

      protected def field_label(id : Int32) : String?
        nil
      end

      protected def set_raw_field(id : Int32, value : String) : Nil
        @data[id] = value
      end
    end
  end
end
