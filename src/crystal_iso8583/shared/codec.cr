module CrystalIso8583
  module Shared
    module Codec
      abstract def encode_mti(mti : MTI) : Bytes
      abstract def decode_mti(bytes : Bytes) : MTI
      abstract def encode_length(length : Int32, digits : Int32) : Bytes
      abstract def decode_length(bytes : Bytes, digits : Int32) : Int32

      class ASCII
        include Codec

        def encode_mti(mti : MTI) : Bytes
          raise NotImplementedError.new("Codec::ASCII#encode_mti")
        end

        def decode_mti(bytes : Bytes) : MTI
          raise NotImplementedError.new("Codec::ASCII#decode_mti")
        end

        def encode_length(length : Int32, digits : Int32) : Bytes
          raise NotImplementedError.new("Codec::ASCII#encode_length")
        end

        def decode_length(bytes : Bytes, digits : Int32) : Int32
          raise NotImplementedError.new("Codec::ASCII#decode_length")
        end
      end

      class BCD
        include Codec

        def encode_mti(mti : MTI) : Bytes
          raise NotImplementedError.new("Codec::BCD#encode_mti")
        end

        def decode_mti(bytes : Bytes) : MTI
          raise NotImplementedError.new("Codec::BCD#decode_mti")
        end

        def encode_length(length : Int32, digits : Int32) : Bytes
          raise NotImplementedError.new("Codec::BCD#encode_length")
        end

        def decode_length(bytes : Bytes, digits : Int32) : Int32
          raise NotImplementedError.new("Codec::BCD#decode_length")
        end
      end
    end
  end
end
