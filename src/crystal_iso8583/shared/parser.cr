module CrystalIso8583
  module Shared
    class Parser
      def initialize(@dictionary : Hash(Int32, FieldDescriptor), @codec : Codec)
      end

      def parse(bytes : Bytes) : Message
        raise NotImplementedError.new("Parser#parse")
      end
    end
  end
end
