module ISO8583
  module V1987
    # Serializes ISO 8583:1987 messages to binary.
    #
    # Wire format mirrors Parser:
    #   [2 bytes BCD MTI][bitmap][data elements in field-number order]
    module Serializer
      # Serialize a message to a Bytes slice
      def self.serialize(message : Message) : Bytes
        io = IO::Memory.new
        write(io, message)
        io.to_slice
      end

      # Write a message directly to any IO
      def self.write(io : IO, message : Message) : Nil
        io.write(message.mti.to_bcd)

        bitmap = message.bitmap
        bitmap.write(io)

        # Write data elements in ascending field-number order, skipping field 1
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
