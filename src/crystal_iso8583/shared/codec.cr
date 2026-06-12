module CrystalIso8583
  module Shared
    module Codec
      abstract def encode_mti(mti : MTI) : Bytes
      abstract def decode_mti(bytes : Bytes) : MTI
      abstract def encode_length(length : Int32, digits : Int32) : Bytes
      abstract def decode_length(bytes : Bytes, digits : Int32) : Int32

      class ASCII
        include Codec
      end

      class BCD
        include Codec
      end
    end
  end
end
