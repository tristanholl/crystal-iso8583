module CrystalISO8583
  module Shared
    struct FieldValue
      getter raw : Bytes
      getter decoded : String

      def initialize(@raw : Bytes, @decoded : String)
      end
    end
  end
end
