module CrystalIso8583
  module Shared
    enum FieldEncoding
      FIXED   # fixed-length field
      LLVAR   # 2-digit length prefix
      LLLVAR  # 3-digit length prefix
    end
  end
end
