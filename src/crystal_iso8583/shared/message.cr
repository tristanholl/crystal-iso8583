module CrystalIso8583
  module Shared
    class Message
      getter mti : MTI
      getter bitmap : Bitmap
      getter fields : Hash(Int32, FieldValue)

      def initialize(@mti, @bitmap, @fields)
      end
    end
  end
end
