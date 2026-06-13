module CrystalIso8583
  module Shared
    struct MTI
      getter version : Int32
      getter message_class : Int32
      getter function : Int32
      getter originator : Int32

      def initialize(@version, @message_class, @function, @originator)
      end
    end
  end
end
