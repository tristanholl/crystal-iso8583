module CrystalIso8583
  module Shared
    class Builder
      def initialize(@dictionary : Hash(Int32, FieldDescriptor), @codec : Codec)
      end

      def build(message : Message) : Bytes
        raise NotImplementedError.new("Builder#build")
      end
    end
  end
end
