module ISO8583
  module Shared
    # Transport-level framing for ISO 8583 messages over IO (files, TCP sockets).
    #
    # The standard 2-byte network header carries the message byte length (big-endian),
    # followed immediately by the message bytes (MTI + bitmap + data elements).
    # This layer is version-agnostic; the version parsers work on the raw message bytes.
    module Codec
      # Read one framed message from IO.
      # Returns the raw message bytes (excluding the 2-byte length header).
      def self.read_frame(io : IO) : Bytes
        header = Bytes.new(2)
        io.read_fully(header)
        length = (header[0].to_i << 8) | header[1].to_i
        frame = Bytes.new(length)
        io.read_fully(frame)
        frame
      end

      # Write one framed message to IO.
      # Prepends the 2-byte big-endian length header.
      def self.write_frame(io : IO, message_bytes : Bytes) : Nil
        len = message_bytes.size
        io.write_byte((len >> 8).to_u8)
        io.write_byte((len & 0xFF).to_u8)
        io.write(message_bytes)
      end
    end
  end
end
