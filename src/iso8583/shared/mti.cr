module ISO8583
  module Shared
    # Message Type Indicator — four decimal digits that identify the message.
    #
    # Position 1 (version):    0 = ISO 8583:1987, 1 = ISO 8583:1993, 2 = ISO 8583:2003
    # Position 2 (class):      1 = Authorization, 2 = Financial, 4 = Reversal, etc.
    # Position 3 (function):   0 = Request, 1 = Response, 2 = Advice, 3 = Advice Response, etc.
    # Position 4 (originator): 0 = Acquirer, 1 = Acquirer Repeat, 2 = Issuer, etc.
    #
    # Wire encoding differs by version:
    #   1987 — 2 bytes BCD  (e.g. "0100" -> [0x01, 0x00])
    #   1993 — 4 bytes ASCII (e.g. "1100" -> [0x31, 0x31, 0x30, 0x30])
    struct MTI
      getter version : Int32
      getter msg_class : Int32
      function_code : Int32
      getter originator : Int32

      def initialize(@version : Int32, @msg_class : Int32,
                     @function_code : Int32, @originator : Int32)
      end

      # The function digit (position 3) — named to avoid clash with Object#function
      def function : Int32
        @function_code
      end

      def self.from_string(s : String) : MTI
        raise ArgumentError.new("MTI must be exactly 4 digits, got: #{s.inspect}") unless s.size == 4
        MTI.new(
          s[0].to_i,
          s[1].to_i,
          s[2].to_i,
          s[3].to_i,
        )
      end

      # Parse from 2 BCD bytes (ISO 8583:1987 wire encoding)
      def self.from_bcd(bytes : Bytes) : MTI
        raise ArgumentError.new("BCD MTI requires 2 bytes") unless bytes.size == 2
        from_string(BCD.decode(bytes, 4))
      end

      # Parse from 4 ASCII bytes (ISO 8583:1993 wire encoding)
      def self.from_ascii(bytes : Bytes) : MTI
        raise ArgumentError.new("ASCII MTI requires 4 bytes") unless bytes.size == 4
        from_string(String.new(bytes))
      end

      def to_s : String
        "#{@version}#{@msg_class}#{@function_code}#{@originator}"
      end

      def to_bcd : Bytes
        BCD.encode(to_s)
      end

      def to_ascii : Bytes
        to_s.to_slice
      end
    end
  end
end
