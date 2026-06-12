require "./messages/auth_request"
require "./messages/auth_response"
require "./messages/auth_advice"
require "./messages/auth_advice_response"

module ISO8583
  module V1993
    # Parses binary ISO 8583:1993 messages.
    #
    # Wire format differences from V1987::Parser:
    #   - MTI is 4 ASCII bytes (e.g. [0x31, 0x31, 0x30, 0x30] for "1100")
    #   - MTI version digit is 1 (1100, 1110, 1120, 1130)
    #   - DE 28-31 are N type (not AN)
    #
    # Variable-length prefix encoding is identical to 1987 (BCD).
    module Parser
      def self.parse(bytes : Bytes) : Message
        parse(IO::Memory.new(bytes))
      end

      def self.parse(io : IO) : Message
        mti = read_mti(io)
        bitmap = Shared::Bitmap.parse(io)
        data_elements = read_data_elements(io, bitmap)
        build_message(mti, data_elements)
      end

      private def self.read_mti(io : IO) : Shared::MTI
        buf = Bytes.new(4)
        io.read_fully(buf)
        Shared::MTI.from_ascii(buf)
      end

      private def self.read_data_elements(
        io : IO,
        bitmap : Shared::Bitmap,
      ) : Hash(Int32, Shared::DataElement)
        elements = {} of Int32 => Shared::DataElement

        bitmap.present_fields.each do |field_num|
          next if field_num == 1

          defn = Dictionary.lookup(field_num) || raise ParseError.new(
            "Field #{field_num} is set in bitmap but has no 1993 dictionary entry")

          raw, char_len = read_field_bytes(io, defn)
          elements[field_num] = Shared::DataElement.new(field_num, raw, char_len, defn)
        end

        elements
      end

      private def self.read_field_bytes(io : IO,
                                        defn : Shared::FieldDefinition) : {Bytes, Int32}
        case defn.length_type
        when Shared::LengthType::Fixed
          raw = Bytes.new(defn.fixed_byte_size)
          io.read_fully(raw)
          {raw, defn.max_length}
        when Shared::LengthType::LLVAR
          len_byte = Bytes.new(1)
          io.read_fully(len_byte)
          char_len = Shared::BCD.decode(len_byte, 2).to_i
          raw = Bytes.new(defn.byte_size_for(char_len))
          io.read_fully(raw)
          {raw, char_len}
        else # LLLVAR
          len_bytes = Bytes.new(2)
          io.read_fully(len_bytes)
          char_len = Shared::BCD.decode(len_bytes, 4).to_i
          raw = Bytes.new(defn.byte_size_for(char_len))
          io.read_fully(raw)
          {raw, char_len}
        end
      end

      private def self.build_message(
        mti : Shared::MTI,
        elements : Hash(Int32, Shared::DataElement),
      ) : Message
        case mti.to_s
        when "1100" then Messages::AuthRequest.new(mti, elements)
        when "1110" then Messages::AuthResponse.new(mti, elements)
        when "1120" then Messages::AuthAdvice.new(mti, elements)
        when "1130" then Messages::AuthAdviceResponse.new(mti, elements)
        else             Message.new(mti, elements)
        end
      end
    end

    class ParseError < Exception
    end
  end
end
