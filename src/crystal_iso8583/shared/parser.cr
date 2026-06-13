module CrystalIso8583
  module Shared
    class Parser
      def initialize(@dictionary : Hash(Int32, FieldDescriptor), @codec : Codec)
      end

      def parse(bytes : Bytes) : Message
        pos = 0

        mti = @codec.decode_mti(bytes[pos, @codec.mti_byte_size])
        pos += @codec.mti_byte_size

        bitmap, bitmap_size = Bitmap.decode(bytes[pos..])
        pos += bitmap_size

        fields = {} of Int32 => FieldValue

        bitmap.field_ids.each do |field_id|
          descriptor = @dictionary[field_id]?
          next unless descriptor

          actual_length = case descriptor.encoding
                          in FieldEncoding::FIXED
                            descriptor.max_length
                          in FieldEncoding::LLVAR
                            ld = @codec.length_byte_size(2)
                            len = @codec.decode_length(bytes[pos, ld], 2)
                            pos += ld
                            len
                          in FieldEncoding::LLLVAR
                            ld = @codec.length_byte_size(3)
                            len = @codec.decode_length(bytes[pos, ld], 3)
                            pos += ld
                            len
                          end

          data_size = @codec.field_byte_size(actual_length, descriptor.data_type)
          raw = bytes[pos, data_size]
          pos += data_size

          decoded = @codec.decode_field(raw, descriptor.data_type, actual_length)
          fields[field_id] = FieldValue.new(raw, decoded)
        end

        Message.new(mti: mti, bitmap: bitmap, fields: fields)
      end
    end
  end
end
