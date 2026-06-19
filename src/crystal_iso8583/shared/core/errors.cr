module CrystalIso8583
  module Shared
    class ISO8583Error < Exception
    end

    class ParseError < ISO8583Error
    end

    class BuildError < ISO8583Error
    end

    class DictionaryError < ISO8583Error
    end
  end
end
