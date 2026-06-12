module ISO8583
  module Shared
    # Represents the ISO 8583 message bitmap (primary 64-bit + optional secondary 64-bit).
    # Bit N (1-indexed, MSB-first) indicates that data element N is present in the message.
    # Bit 1 of the primary bitmap is the secondary-bitmap present flag.
    struct Bitmap
      PRIMARY_BYTES   = 8
      SECONDARY_BYTES = 8

      getter bytes : Bytes

      def initialize(@bytes : Bytes)
      end

      # Read bitmap from IO. Always reads 8 bytes (primary); reads 8 more if bit 1 is set.
      def self.parse(io : IO) : Bitmap
        primary = Bytes.new(PRIMARY_BYTES)
        io.read_fully(primary)

        if (primary[0] & 0x80_u8) != 0
          secondary = Bytes.new(SECONDARY_BYTES)
          io.read_fully(secondary)
          combined = Bytes.new(PRIMARY_BYTES + SECONDARY_BYTES)
          primary.copy_to(combined)
          secondary.copy_to(combined[PRIMARY_BYTES..])
          Bitmap.new(combined)
        else
          Bitmap.new(primary.dup)
        end
      end

      # Build a bitmap from a collection of field numbers (1-indexed).
      # Field 1 is the secondary-bitmap indicator and is set automatically when needed.
      def self.build(field_numbers : Enumerable(Int32)) : Bitmap
        relevant = field_numbers.reject { |n| n == 1 }.to_a
        needs_secondary = relevant.any? { |n| n > 64 }
        size = needs_secondary ? PRIMARY_BYTES + SECONDARY_BYTES : PRIMARY_BYTES

        bmp = Bytes.new(size, 0_u8)
        bmp[0] = (bmp[0] | 0x80_u8).to_u8 if needs_secondary

        relevant.each do |n|
          next if n < 2 || n > size * 8
          byte_idx = (n - 1) // 8
          bit_pos  = 7 - ((n - 1) % 8)
          bmp[byte_idx] = (bmp[byte_idx] | (1 << bit_pos)).to_u8
        end

        Bitmap.new(bmp)
      end

      def field_present?(n : Int32) : Bool
        return false if n < 1
        byte_idx = (n - 1) // 8
        bit_pos  = 7 - ((n - 1) % 8)
        return false if byte_idx >= bytes.size
        ((bytes[byte_idx] >> bit_pos) & 1) == 1
      end

      def present_fields : Array(Int32)
        (1..(bytes.size * 8)).select { |n| field_present?(n) }.to_a
      end

      def has_secondary? : Bool
        bytes.size >= PRIMARY_BYTES && (bytes[0] & 0x80_u8) != 0
      end

      def write(io : IO) : Nil
        io.write(bytes)
      end
    end
  end
end
