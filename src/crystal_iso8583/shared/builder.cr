module CrystalISO8583
  module Shared
    class Builder
      def initialize(@dictionary : Hash(Int32, FieldDescriptor), @codec : Codec)
      end

      def build(message : Message) : Bytes
        bitmap = Bitmap.new
        message.fields.each_key do |id|
          raise BuildError.new("Field #{id}: field ID must be in range 1..128") unless 1 <= id <= 128
          bitmap.set(id)
        end

        io = IO::Memory.new
        io.write(@codec.encode_mti(message.mti))
        io.write(bitmap.encode)

        message.fields.keys.sort.each do |field_id|
          descriptor = @dictionary[field_id]?
          raise BuildError.new("Field #{field_id} not in dictionary") unless descriptor

          fv = message.fields[field_id]
          str = fv.decoded

          validate_field_value!(field_id, str, descriptor)

          if descriptor.data_type == DataType::B
            raw = str.hexbytes
            if descriptor.encoding == FieldEncoding::FIXED && raw.size != descriptor.max_length
              raise BuildError.new(
                "Field #{field_id} (#{descriptor.label}): binary value is #{raw.size} bytes, " \
                "expected exactly #{descriptor.max_length} for a FIXED field"
              )
            elsif descriptor.encoding != FieldEncoding::FIXED && raw.size > descriptor.max_length
              raise BuildError.new(
                "Field #{field_id} (#{descriptor.label}): binary value is #{raw.size} bytes, " \
                "exceeds maximum #{descriptor.max_length}"
              )
            end
            write_field(io, raw, descriptor.encoding, raw.size)
          else
            if descriptor.encoding != FieldEncoding::FIXED && str.size > descriptor.max_length
              raise BuildError.new(
                "Field #{field_id} (#{descriptor.label}): value length #{str.size} " \
                "exceeds maximum #{descriptor.max_length}"
              )
            end
            encoded = @codec.encode_field(str, descriptor.data_type)
            encoded = pad_fixed(encoded, descriptor) if descriptor.encoding == FieldEncoding::FIXED
            write_field(io, encoded, descriptor.encoding, str.size)
          end
        end

        io.to_slice
      end

      private def validate_field_value!(field_id : Int32, str : String, descriptor : FieldDescriptor) : Nil
        case descriptor.data_type
        when DataType::N
          unless str.each_char.all?(&.ascii_number?)
            raise BuildError.new(
              "Field #{field_id} (#{descriptor.label}): numeric field value must contain only digits"
            )
          end
        when DataType::B
          valid_hex = str.size.even? && str.each_char.all? { |c| c.ascii_number? || ('a'..'f').includes?(c) }
          unless valid_hex
            raise BuildError.new(
              "Field #{field_id} (#{descriptor.label}): binary field value must be a lowercase hex string"
            )
          end
        end
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
        in FieldEncoding::LLLLVAR
          io.write(@codec.encode_length(logical_length, 4))
          io.write(data)
        end
      end

      private def pad_fixed(encoded : Bytes, descriptor : FieldDescriptor) : Bytes
        expected = @codec.field_byte_size(descriptor.max_length, descriptor.data_type)
        if encoded.size > expected
          raise BuildError.new(
            "Field #{descriptor.id} (#{descriptor.label}): encoded length #{encoded.size} bytes " \
            "exceeds fixed-field size #{expected} bytes"
          )
        end
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
