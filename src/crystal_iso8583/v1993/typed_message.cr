module CrystalIso8583
  module V1993
    # Abstract base for all V1993 typed messages.
    # Wires the DataDictionary into build/parse so callers only pass a codec.
    abstract class TypedMessage < Shared::TypedMessage
      def build(codec : Shared::Codec) : Bytes
        build(codec, DataDictionary.fields)
      end

      def self.parse(bytes : Bytes, codec : Shared::Codec)
        parse(bytes, codec, DataDictionary.fields)
      end
    end
  end
end
