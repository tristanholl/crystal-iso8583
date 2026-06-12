module CrystalIso8583
  class Parser
    def self.parse(raw : String) : Message
      raise ArgumentError.new("Message too short") if raw.size < 20

      mti = raw[0..3]
      message = Message.new(mti)

      bitmap_hex = raw[4..19]
      primary = bitmap_hex.to_u64(16)
      message.bitmap.instance_variable_set(:@primary, primary)

      message
    end
  end
end
