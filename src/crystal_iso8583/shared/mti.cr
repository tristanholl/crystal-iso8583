module CrystalIso8583
  module Shared
    struct MTI
      getter version : Int32
      getter message_class : Int32
      getter function : Int32
      getter originator : Int32

      def initialize(@version, @message_class, @function, @originator)
      end

      def self.parse(str : String) : MTI
        raise ArgumentError.new("MTI must be exactly 4 digits, got #{str.inspect}") unless str.size == 4 && str.each_char.all? { |c| '0' <= c <= '9' }
        new(
          version: str[0].to_i,
          message_class: str[1].to_i,
          function: str[2].to_i,
          originator: str[3].to_i
        )
      end

      def to_s(io : IO) : Nil
        io << version << message_class << function << originator
      end
    end
  end
end
