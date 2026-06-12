module CrystalIso8583
  class Message
    getter mti : String
    getter bitmap : Bitmap
    getter fields : Hash(Int32, Field)

    def initialize(@mti : String)
      @bitmap = Bitmap.new
      @fields = Hash(Int32, Field).new
    end

    def set_field(field : Field) : Void
      @bitmap.set(field.id)
      @fields[field.id] = field
    end

    def get_field(id : Int32) : Field?
      @fields[id]?
    end

    def encode : String
      body = @fields.keys.sort.map { |id| @fields[id].encode }.join
      "#{@mti}#{@bitmap.to_hex}#{body}"
    end
  end
end
