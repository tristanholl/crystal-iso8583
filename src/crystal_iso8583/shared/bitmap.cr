module CrystalISO8583
  module Shared
    class Bitmap
      def initialize
        @bits = Array(Bool).new(128, false)
      end

      def set(field_id : Int32) : Nil
        raise ArgumentError.new("field_id must be 1..128, got #{field_id}") unless 1 <= field_id <= 128
        @bits[field_id - 1] = true
        @bits[0] = true if field_id > 64
      end

      def set?(field_id : Int32) : Bool
        1 <= field_id <= 128 && @bits[field_id - 1]
      end

      # Returns data-field ids that are present (excludes field 1, the secondary-bitmap indicator).
      def field_ids : Array(Int32)
        (2..128).select { |i| @bits[i - 1] }.to_a
      end

      def has_secondary? : Bool
        @bits[0]
      end

      def encode : Bytes
        byte_count = has_secondary? ? 16 : 8
        result = Bytes.new(byte_count)
        byte_count.times do |bi|
          byte = 0u8
          8.times { |bi2| byte |= (0x80u8 >> bi2) if @bits[bi * 8 + bi2] }
          result[bi] = byte
        end
        result
      end

      # Returns {bitmap, bytes_consumed}.
      def self.decode(bytes : Bytes) : {Bitmap, Int32}
        bm = new
        8.times do |bi|
          8.times { |bi2| bm.@bits[bi * 8 + bi2] = (bytes[bi] & (0x80u8 >> bi2)) != 0 }
        end
        consumed = 8
        if bm.has_secondary? && bytes.size >= 16
          8.times do |bi|
            8.times { |bi2| bm.@bits[64 + bi * 8 + bi2] = (bytes[8 + bi] & (0x80u8 >> bi2)) != 0 }
          end
          consumed = 16
        end
        {bm, consumed}
      end
    end
  end
end
