module CrystalISO8583
  module Shared
    # Shared packed Binary Coded Decimal helpers used by Codec::BCD and Codec::Configurable.
    module BCDUtil
      def self.pack(digits : String) : Bytes
        padded = digits.size.odd? ? "0" + digits : digits
        Bytes.new(padded.size // 2) { |i| (((padded[i * 2] - '0') << 4) | (padded[i * 2 + 1] - '0')).to_u8 }
      end

      def self.unpack(bytes : Bytes) : String
        String.build(bytes.size * 2) do |sb|
          bytes.each do |b|
            sb << ((b >> 4) & 0x0F)
            sb << (b & 0x0F)
          end
        end
      end

      # Track 2 (ISO 7813) nibble packing: digits map to 0x0-0x9 as usual, the
      # field separator '=' maps to nibble 0xD, and a trailing 0xF pad nibble
      # is appended when the digit count is odd.
      def self.pack_track2(str : String) : Bytes
        padded = str.size.odd? ? str + "F" : str
        Bytes.new(padded.size // 2) { |i| ((track2_nibble(padded[i * 2]) << 4) | track2_nibble(padded[i * 2 + 1])).to_u8 }
      end

      def self.unpack_track2(bytes : Bytes) : String
        String.build(bytes.size * 2) do |sb|
          bytes.each do |b|
            sb << track2_char((b >> 4) & 0x0F)
            sb << track2_char(b & 0x0F)
          end
        end
      end

      private def self.track2_nibble(c : Char) : UInt8
        case c
        when '=' then 0xD_u8
        when 'F' then 0xF_u8
        else          (c - '0').to_u8
        end
      end

      private def self.track2_char(nibble : UInt8) : Char
        case nibble
        when 0xD_u8 then '='
        when 0xF_u8 then 'F'
        else             ('0'.ord + nibble).chr
        end
      end
    end
  end
end
