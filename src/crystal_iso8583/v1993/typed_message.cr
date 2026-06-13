module CrystalIso8583
  module V1993
    # Abstract base for all V1993 typed messages.
    # Wires the DataDictionary into build/parse so callers only pass a codec.
    abstract class TypedMessage < Shared::TypedMessage
      def validate! : Nil
        dict = DataDictionary.fields
        missing = field_meta
          .select { |_, required| required }
          .keys
          .reject { |id| @data.has_key?(id) }
          .map { |id| dict[id]?.try { |f| "#{id} (#{f.label})" } || id.to_s }
        raise Shared::BuildError.new("Missing required fields: #{missing.join(", ")}") unless missing.empty?
      end

      protected def field_label(id : Int32) : String?
        DataDictionary.fields[id]?.try(&.label)
      end

      def build(codec : Shared::Codec) : Bytes
        build(codec, DataDictionary.fields)
      end

      def self.parse(bytes : Bytes, codec : Shared::Codec)
        parse(bytes, codec, DataDictionary.fields)
      end
    end
  end
end
