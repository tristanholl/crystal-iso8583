module ISO8583
  module V1993
    # Serializes ISO 8583:1993 messages to binary.
    # Identical to V1987::Serializer except the MTI is written as 4 ASCII bytes.
    module Serializer
      def self.serialize(message : Message) : Bytes
        io = IO::Memory.new
        write(io, message)
        io.to_slice
      end

      def self.write(io : IO, message : Message) : Nil
        io.write(message.mti.to_ascii)

        bitmap = message.bitmap
        bitmap.write(io)

        message.data_elements.keys.sort.each do |field_num|
          next if field_num == 1
          de = message.data_elements[field_num]
          write_field(io, de)
        end
      end

      private def self.write_field(io : IO, de : Shared::DataElement) : Nil
        case de.definition.length_type
        when Shared::LengthType::Fixed
          io.write(de.raw_bytes)
        when Shared::LengthType::LLVAR
          io.write(Shared::BCD.encode(de.char_length.to_s.rjust(2, '0')))
          io.write(de.raw_bytes)
        else # LLLVAR
          io.write(Shared::BCD.encode(de.char_length.to_s.rjust(4, '0')))
          io.write(de.raw_bytes)
        end
      end
    end
  end
end
