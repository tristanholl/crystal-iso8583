require "./messages/auth_request"
require "./messages/auth_response"
require "./messages/auth_advice"
require "./messages/auth_advice_response"

module ISO8583
  module V1987
    # Parses binary ISO 8583:1987 messages.
    #
    # Wire format:
    #   [2 bytes BCD MTI][8 bytes primary bitmap][optional 8 bytes secondary bitmap]
    #   [data elements in field-number order]
    #
    # Variable-length prefixes:
    #   LLVAR  — 1 byte BCD (encodes 2 digits, 00-99)
    #   LLLVAR — 2 bytes BCD (encodes "0NNN", last 3 digits give length 000-999)
    module Parser
      # Parse from a raw byte slice
      def self.parse(bytes : Bytes) : Message
        parse(IO::Memory.new(bytes))
      end

      # Parse from any IO (file, TCP socket, IO::Memory)
      def self.parse(io : IO) : Message
        mti = read_mti(io)
        bitmap = Shared::Bitmap.parse(io)
        data_elements = read_data_elements(io, bitmap)
        build_message(mti, data_elements)
      end

      private def self.read_mti(io : IO) : Shared::MTI
        buf = Bytes.new(2)
        io.read_fully(buf)
        Shared::MTI.from_bcd(buf)
      end

      private def self.read_data_elements(
        io : IO,
        bitmap : Shared::Bitmap,
      ) : Hash(Int32, Shared::DataElement)
        elements = {} of Int32 => Shared::DataElement

        bitmap.present_fields.each do |field_num|
          next if field_num == 1 # secondary bitmap — already consumed

          defn = Dictionary.lookup(field_num) || raise ParseError.new(
            "Field #{field_num} is set in bitmap but has no 1987 dictionary entry")

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
        when "0100" then Messages::AuthRequest.new(mti, elements)
        when "0110" then Messages::AuthResponse.new(mti, elements)
        when "0120" then Messages::AuthAdvice.new(mti, elements)
        when "0130" then Messages::AuthAdviceResponse.new(mti, elements)
        else             Message.new(mti, elements)
        end
      end
    end

    class ParseError < Exception
    end
  end
end
