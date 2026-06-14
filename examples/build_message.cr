require "../src/crystal_iso8583"

# Build an ISO 8583 v1993 authorization request (1100) using the typed message
# API and write the binary payload to a file.
#
# ISO 8583 messages transported over TCP are typically prefixed with a 4-byte
# network length indicator. This example writes the raw payload without that
# header; prepend it if your transport layer requires it.

codec     = CrystalIso8583::Shared::Codec::ASCII.new
output    = ARGV[0]? || "data/out/msg_1100_built.bin"

msg = CrystalIso8583::V1993::Msg1100.new
msg.iso002 = "4349710000001380"   # Primary Account Number (PAN)
msg.iso003 = "310000"             # Processing Code
msg.iso004 = "000000001000"       # Amount, Transaction (10.00 in minor units)
msg.iso007 = "0614120000"         # Date and Time, Transmission (MMDDhhmmss)
msg.iso011 = "000001"             # System Trace Audit Number (STAN)
msg.iso012 = "260614120000"       # Date and Time, Local Transaction
msg.iso022 = "021000000000"       # POS Data Code
msg.iso024 = "100"                # Function Code
msg.iso026 = "5411"               # Card Acceptor Business Code (MCC)
msg.iso032 = "27200"              # Acquiring Institution Identification Code
msg.iso037 = "000000000001"       # Retrieval Reference Number
msg.iso041 = "TERM0001"           # Card Acceptor Terminal ID
msg.iso042 = "MERCH001       "    # Card Acceptor ID Code (15 chars)
msg.iso043 = "My Shop\\Berlin\\10115\\DE"  # Card Acceptor Name/Location
msg.iso048 = "001EAPS"            # Additional Data — Private
msg.iso049 = "978"                # Currency Code, Transaction (EUR)

bytes = msg.build(codec)

Dir.mkdir_p(File.dirname(output))
File.open(output, "wb") { |f| f.write(bytes) }

puts "Written #{bytes.size} bytes to #{output}"
puts msg.to_json
