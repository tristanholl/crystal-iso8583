module CrystalIso8583
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
    end
  end
end
