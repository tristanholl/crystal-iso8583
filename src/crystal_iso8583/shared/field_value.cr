module CrystalIso8583
  module Shared
    struct FieldValue
      getter raw : Bytes
      getter decoded : String | Int64 | Bytes

      def initialize(@raw : Bytes, @decoded : String | Int64 | Bytes)
      end
    end
  end
end
