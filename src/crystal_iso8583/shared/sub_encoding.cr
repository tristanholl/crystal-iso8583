module CrystalIso8583
  module Shared
    # Per-concern wire encoding used by Codec::Configurable.
    enum SubEncoding
      ASCII
      BCD
      EBCDIC
      Binary # valid only for length prefixes
    end
  end
end
