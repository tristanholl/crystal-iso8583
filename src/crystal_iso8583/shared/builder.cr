module CrystalIso8583
  module Shared
    class Builder
      def initialize(@dictionary : Hash(Int32, FieldDescriptor), @codec : Codec)
      end

      def build(message : Message) : Bytes
        bitmap = Bitmap.new
        message.fields.each_key { |id| bitmap.set(id) }

        io = IO::Memory.new
        io.write(@codec.encode_mti(message.mti))
        io.write(bitmap.encode)

        message.fields.keys.sort.each do |field_id|
          descriptor = @dictionary[field_id]?
          raise BuildError.new("Field #{field_id} not in dictionary") unless descriptor

          fv = message.fields[field_id]
          str = fv.decoded

          if descriptor.data_type == DataType::B
            raw = str.hexbytes
            write_field(io, raw, descriptor.encoding, raw.size)
          else
            encoded = @codec.encode_field(str, descriptor.data_type)
            encoded = pad_fixed(encoded, descriptor) if descriptor.encoding == FieldEncoding::FIXED
            write_field(io, encoded, descriptor.encoding, str.size)
          end
        end

        io.to_slice
      end

      private def write_field(io : IO, data : Bytes, encoding : FieldEncoding, logical_length : Int32) : Nil
        case encoding
        in FieldEncoding::FIXED
          io.write(data)
        in FieldEncoding::LLVAR
          io.write(@codec.encode_length(logical_length, 2))
          io.write(data)
        in FieldEncoding::LLLVAR
          io.write(@codec.encode_length(logical_length, 3))
          io.write(data)
        end
      end

      private def pad_fixed(encoded : Bytes, descriptor : FieldDescriptor) : Bytes
        expected = @codec.field_byte_size(descriptor.max_length, descriptor.data_type)
        return encoded if encoded.size == expected
        result = Bytes.new(expected)
        if descriptor.data_type == DataType::N
          # Left-pad numeric fields with zeros.
          offset = expected - encoded.size
          encoded.copy_to(result + offset)
        else
          # Right-pad text fields with spaces (0x20).
          result.fill(0x20u8)
          encoded.copy_to(result)
        end
        result
      end
    end
  end
end
