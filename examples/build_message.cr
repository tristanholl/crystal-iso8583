require "../src/crystal_iso8583"

# ISO 8583 messages transported over TCP are typically prefixed with a 4-byte
# big-endian network length indicator containing the byte length of the payload
# that follows. This example writes the full framed message by default.
#
# Usage:
#   crystal run examples/build_message.cr                         # with header → data/out/msg_1100_built.bin
#   crystal run examples/build_message.cr -- out.bin              # custom output, with header
#   crystal run examples/build_message.cr -- out.bin no-header    # skip the network header
NETWORK_HEADER_SIZE = 4

codec      = CrystalIso8583::Shared::Codec::ASCII.new
output     = ARGV[0]? || "data/out/msg_1100_built.bin"
add_header = ARGV[1]? != "no-header"

msg = CrystalIso8583::V1993::Msg1100.new
msg.iso002 = "4349710000001380"           # Primary Account Number (PAN)
msg.iso003 = "310000"                     # Processing Code
msg.iso004 = "000000001000"               # Amount, Transaction (10.00 in minor units)
msg.iso007 = "0614120000"                 # Date and Time, Transmission (MMDDhhmmss)
msg.iso011 = "000001"                     # System Trace Audit Number (STAN)
msg.iso012 = "260614120000"               # Date and Time, Local Transaction
msg.iso022 = "021000000000"               # POS Data Code
msg.iso024 = "100"                        # Function Code
msg.iso026 = "5411"                       # Card Acceptor Business Code (MCC)
msg.iso032 = "27200"                      # Acquiring Institution Identification Code
msg.iso037 = "000000000001"               # Retrieval Reference Number
msg.iso041 = "TERM0001"                   # Card Acceptor Terminal ID
msg.iso042 = "MERCH001       "            # Card Acceptor ID Code (15 chars)
msg.iso043 = "My Shop\\Berlin\\10115\\DE" # Card Acceptor Name/Location
msg.iso048 = "001EAPS"                    # Additional Data — Private
msg.iso049 = "978"                        # Currency Code, Transaction (EUR)

iso_bytes = msg.build(codec)

payload = if add_header
            length_prefix = iso_bytes.size.to_s.rjust(NETWORK_HEADER_SIZE, '0').to_slice
            length_prefix + iso_bytes
          else
            iso_bytes
          end

Dir.mkdir_p(File.dirname(output))
File.open(output, "wb") { |f| f.write(payload) }

header_note = add_header ? "with #{NETWORK_HEADER_SIZE}-byte network header" : "no network header"
puts "ISO message : #{iso_bytes.size} bytes"
puts "Written     : #{payload.size} bytes (#{header_note}) → #{output}"
puts msg.to_json
