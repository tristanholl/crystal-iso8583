module CrystalIso8583
  enum FieldType
    Fixed
    LLVAR  # 2-digit length prefix
    LLLVAR # 3-digit length prefix
  end

  struct Field
    getter id : Int32
    getter type : FieldType
    getter max_length : Int32
    getter value : String

    def initialize(@id : Int32, @type : FieldType, @max_length : Int32, @value : String = "")
    end

    def with_value(value : String) : Field
      Field.new(@id, @type, @max_length, value)
    end

    def encode : String
      case @type
      when FieldType::Fixed
        @value.ljust(@max_length)
      when FieldType::LLVAR
        "%02d%s" % [@value.size, @value]
      when FieldType::LLLVAR
        "%03d%s" % [@value.size, @value]
      else
        @value
      end
    end
  end
end
