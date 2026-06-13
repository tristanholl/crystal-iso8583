module CrystalIso8583
  module Shared
    module Codec
      abstract def encode_mti(mti : MTI) : Bytes
      abstract def decode_mti(bytes : Bytes) : MTI
      abstract def encode_length(length : Int32, digits : Int32) : Bytes
      abstract def decode_length(bytes : Bytes, digits : Int32) : Int32
      abstract def encode_string(str : String) : Bytes
      abstract def decode_string(bytes : Bytes) : String

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

        def encode_string(str : String) : Bytes
          raise NotImplementedError.new("Codec::ASCII#encode_string")
        end

        def decode_string(bytes : Bytes) : String
          raise NotImplementedError.new("Codec::ASCII#decode_string")
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

        def encode_string(str : String) : Bytes
          raise NotImplementedError.new("Codec::BCD#encode_string")
        end

        def decode_string(bytes : Bytes) : String
          raise NotImplementedError.new("Codec::BCD#decode_string")
        end
      end

      class EBCDIC
        include Codec

        def encode_mti(mti : MTI) : Bytes
          raise NotImplementedError.new("Codec::EBCDIC#encode_mti")
        end

        def decode_mti(bytes : Bytes) : MTI
          raise NotImplementedError.new("Codec::EBCDIC#decode_mti")
        end

        def encode_length(length : Int32, digits : Int32) : Bytes
          raise NotImplementedError.new("Codec::EBCDIC#encode_length")
        end

        def decode_length(bytes : Bytes, digits : Int32) : Int32
          raise NotImplementedError.new("Codec::EBCDIC#decode_length")
        end

        def encode_string(str : String) : Bytes
          raise NotImplementedError.new("Codec::EBCDIC#encode_string")
        end

        def decode_string(bytes : Bytes) : String
          raise NotImplementedError.new("Codec::EBCDIC#decode_string")
        end
      end
    end
  end
end
