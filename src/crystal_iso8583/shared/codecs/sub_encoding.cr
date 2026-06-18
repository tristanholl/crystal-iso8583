module CrystalIso8583
  module Shared
    module Codec
      # Per-concern wire encodings used by Codec::Configurable. Split into
      # one enum per concern (rather than a single shared enum) so the type
      # system rules out invalid combinations, e.g. passing Binary as a
      # text_encoding, instead of needing a runtime check.

      # MTI sub-encoding.
      enum MtiEncoding
        ASCII
        BCD
        EBCDIC
      end

      # Numeric (N) field data sub-encoding.
      enum NumericEncoding
        ASCII
        BCD
        EBCDIC
      end

      # Alphanumeric/special (AN/ANS/Z) field data sub-encoding.
      enum TextEncoding
        ASCII
        EBCDIC
      end

      # Variable-length field prefix sub-encoding. Binary means a raw
      # unsigned integer of `binary_length_byte_size` bytes (see
      # Codec::Configurable), not a digit-character or BCD-nibble encoding.
      enum LengthEncoding
        ASCII
        BCD
        EBCDIC
        Binary
      end
    end
  end
end
