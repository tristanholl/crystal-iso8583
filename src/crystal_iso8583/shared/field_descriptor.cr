module CrystalIso8583
  module Shared
    struct FieldDescriptor
      getter id : Int32
      getter encoding : FieldEncoding
      getter max_length : Int32
      getter data_type : DataType
      getter label : String

      def initialize(@id, @encoding, @max_length, @data_type, @label)
      end
    end
  end
end
