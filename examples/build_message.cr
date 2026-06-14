require "../src/crystal_iso8583"

# Build an ISO 8583 v1993 authorization request (1100) using the typed message
# API and write the framed payload to a file.
#
# ISO 8583 messages transported over TCP are typically prefixed with a 4-byte
# ASCII decimal network length indicator (e.g. "0306" for a 306-byte message).
# This example writes the full framed message by default.
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
msg.iso002 = "4349750003416619"                           # Primary Account Number (PAN)
msg.iso003 = "000000"                                     # Processing Code
msg.iso004 = "000000000079"                               # Amount, Transaction
msg.iso006 = "000000000079"                               # Amount, Cardholder Billing
msg.iso007 = "0303194156"                                 # Date and Time, Transmission (MMDDhhmmss)
msg.iso011 = "259059"                                     # System Trace Audit Number (STAN)
msg.iso012 = "210303194156"                               # Date and Time, Local Transaction
msg.iso014 = "2402"                                       # Date, Expiration
msg.iso022 = "L10101L5500C"                               # POS Data Code
msg.iso023 = "000"                                        # Card Sequence Number
msg.iso024 = "100"                                        # Function Code
msg.iso025 = "1403"                                       # Message Reason Code
msg.iso026 = "5411"                                       # Card Acceptor Business Code (MCC)
msg.iso032 = "483072"                                     # Acquiring Institution Identification Code
msg.iso033 = "12928"                                      # Forwarding Institution Identification Code
msg.iso037 = "106218259059"                               # Retrieval Reference Number
msg.iso039 = "100"                                        # Action Code
msg.iso041 = "56034449"                                   # Card Acceptor Terminal Identification
msg.iso042 = "4556336799     "                            # Card Acceptor Identification Code (15 chars)
msg.iso043 = "REWE Markt GmbH-Zw\\\\Berlin\\             DEU"  # Card Acceptor Name/Location
msg.iso048 = "001"                                        # Additional Data — Private
msg.iso049 = "978"                                        # Currency Code, Transaction (EUR)
msg.iso051 = "978"                                        # Currency Code, Cardholder Billing (EUR)
msg.iso063 = "0315481062673163064"                        # Network Data
msg.iso093 = "12928"                                      # Transaction Destination Institution ID
msg.iso094 = "483072"                                     # Transaction Originator Institution ID
msg.iso100 = "00000000000"                                # Receiving Institution Identification Code
msg.iso102 = "500004684881           "                    # Account Identification 1
msg.iso116 = "05000040"                                   # POS Data

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
