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
msg.iso002 = "4349750003416619"                                  # Primary Account Number (PAN)
msg.iso003 = "000000"                                            # Processing Code
msg.iso004 = "000000001000"                                      # Amount, Transaction
msg.iso006 = "000000001000"                                      # Amount, Cardholder Billing
msg.iso007 = "0302143124"                                        # Date and Time, Transmission (MMDDhhmmss)
msg.iso011 = "171374"                                            # System Trace Audit Number (STAN)
msg.iso012 = "210302143124"                                      # Date and Time, Local Transaction
msg.iso014 = "2402"                                              # Date, Expiration
msg.iso022 = "100050J00010"                                      # POS Data Code
msg.iso023 = "000"                                               # Card Sequence Number
msg.iso024 = "100"                                               # Function Code
msg.iso026 = "6012"                                              # Card Acceptor Business Code (MCC)
msg.iso032 = "487115"                                            # Acquiring Institution Identification Code
msg.iso033 = "12928"                                             # Forwarding Institution Identification Code
msg.iso037 = "106113171374"                                      # Retrieval Reference Number
msg.iso038 = "252284"                                            # Approval Code
msg.iso041 = "99999999"                                          # Card Acceptor Terminal Identification
msg.iso042 = "000000000206535"                                   # Card Acceptor Identification Code (15 chars)
msg.iso043 = "Revolut**8624*\\\\GBR\\             LTU"          # Card Acceptor Name/Location
msg.iso049 = "978"                                               # Currency Code, Transaction (EUR)
msg.iso051 = "978"                                               # Currency Code, Cardholder Billing (EUR)
msg.iso063 = "0315481061486847479"                               # Network Data
msg.iso093 = "12928"                                             # Transaction Destination Institution ID
msg.iso094 = "487115"                                            # Transaction Originator Institution ID
msg.iso100 = "00000000000"                                       # Receiving Institution Identification Code
msg.iso102 = "500004684881           "                           # Account Identification 1
msg.iso116 = "5900000005"                                        # POS Data

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
