module CrystalIso8583
  module Shared
    # Strategies for stripping/wrapping transport-layer framing that sits in
    # front of the actual ISO 8583 message (TPDUs, proprietary network
    # headers, length prefixes, etc).
    module Header
      module Strategy
        # Returns the ISO 8583 payload with the header removed.
        abstract def strip(bytes : Bytes) : Bytes

        # Returns `iso_bytes` with the header prepended.
        abstract def wrap(iso_bytes : Bytes) : Bytes
      end

      # Skips a fixed number of opaque bytes (e.g. a proprietary TPDU or
      # record-type tag) that carries no length information.
      class FixedLength
        include Strategy

        def initialize(@size : Int32)
        end

        def strip(bytes : Bytes) : Bytes
          bytes[@size..]
        end

        def wrap(iso_bytes : Bytes) : Bytes
          Bytes.new(@size) + iso_bytes
        end
      end

      # An N-digit ASCII decimal length prefix indicating the byte size of
      # the ISO 8583 message that follows (the common TCP framing convention).
      class AsciiLengthPrefix
        include Strategy

        def initialize(@digits : Int32 = 4)
        end

        def strip(bytes : Bytes) : Bytes
          bytes[@digits..]
        end

        def wrap(iso_bytes : Bytes) : Bytes
          iso_bytes.size.to_s.rjust(@digits, '0').to_slice + iso_bytes
        end
      end
    end
  end
end
