module CrystalIso8583
  class Bitmap
    BITMAP_SIZE = 64

    getter primary : UInt64
    getter secondary : UInt64

    def initialize(@primary : UInt64 = 0_u64, @secondary : UInt64 = 0_u64)
    end

    def set(field_id : Int32) : Void
      raise ArgumentError.new("Field ID must be between 1 and 128") unless (1..128).includes?(field_id)

      if field_id <= 64
        bit = BITMAP_SIZE - field_id
        @primary |= (1_u64 << bit)
        @primary |= (1_u64 << 63) if has_secondary?
      else
        bit = 128 - field_id
        @secondary |= (1_u64 << bit)
        @primary |= (1_u64 << 63)
      end
    end

    def present?(field_id : Int32) : Bool
      if field_id <= 64
        bit = BITMAP_SIZE - field_id
        (@primary & (1_u64 << bit)) != 0
      else
        bit = 128 - field_id
        (@secondary & (1_u64 << bit)) != 0
      end
    end

    def has_secondary? : Bool
      (@primary & (1_u64 << 63)) != 0
    end

    def to_hex : String
      if has_secondary?
        "%016X%016X" % [@primary, @secondary]
      else
        "%016X" % @primary
      end
    end
  end
end
