module CrystalIso8583
  module Shared
    class Parser
      def initialize(@dictionary : Hash(Int32, FieldDescriptor), @codec : Codec)
      end

      def parse(bytes : Bytes) : Message
        pos = 0

        mti = @codec.decode_mti(read_bytes(bytes, pos, @codec.mti_byte_size, "MTI"))
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
                            len = @codec.decode_length(read_bytes(bytes, pos, ld, "LLVAR length prefix", field_id), 2)
                            pos += ld
                            len
                          in FieldEncoding::LLLVAR
                            ld = @codec.length_byte_size(3)
                            len = @codec.decode_length(read_bytes(bytes, pos, ld, "LLLVAR length prefix", field_id), 3)
                            pos += ld
                            len
                          in FieldEncoding::LLLLVAR
                            ld = @codec.length_byte_size(4)
                            len = @codec.decode_length(bytes[pos, ld], 4)
                            pos += ld
                            len
                          end

          data_size = @codec.field_byte_size(actual_length, descriptor.data_type)
          raw = read_bytes(bytes, pos, data_size, "field data", field_id)
          pos += data_size

          decoded = @codec.decode_field(raw, descriptor.data_type, actual_length)
          fields[field_id] = FieldValue.new(raw, decoded)
        end

        Message.new(mti: mti, bitmap: bitmap, fields: fields)
      end

      private def read_bytes(bytes : Bytes, pos : Int32, size : Int32, context : String, field_id : Int32? = nil) : Bytes
        if pos + size > bytes.size
          field_info = field_id ? " (field #{field_id})" : ""
          raise ParseError.new(
            "Buffer overrun reading #{context}#{field_info}: " \
            "need #{size} bytes at offset #{pos}, but message is only #{bytes.size} bytes"
          )
        end
        bytes[pos, size]
      end
    end
  end
end
