require "../src/crystal_iso8583"
require "option_parser"

# Build an ISO 8583 authorization request using the typed message API and
# write the framed payload to a file. Supports both the 1987 (Msg0100) and
# 1993 (Msg1100) message versions.
#
# ISO 8583 messages transported over TCP are typically prefixed with a 4-byte
# ASCII decimal network length indicator (e.g. "0306" for a 306-byte message).
# This example writes the full framed message by default.
NETWORK_HEADER_SIZE = 4

version = "1993"
codec_name = nil
output = nil
add_header = true

OptionParser.parse do |parser|
  parser.banner = "Usage: crystal run examples/build_message.cr -- [options]"

  parser.on("--version VERSION", "Message version: 1987 or 1993 (default: 1993)") { |v| version = v }
  parser.on("--codec CODEC", "Codec: ascii, bcd, or ebcdic (default: ascii for 1993, ebcdic for 1987)") { |c| codec_name = c }
  parser.on("-o FILE", "--output FILE", "Output file (default: data/out/msg_<mti>_built.bin)") { |f| output = f }
  parser.on("--no-header", "Omit the 4-byte ASCII network length prefix") { add_header = false }
  parser.on("-h", "--help", "Show this help") { puts parser; exit 0 }

  parser.invalid_option do |flag|
    STDERR.puts "Unknown flag: #{flag}"
    STDERR.puts parser
    exit 1
  end
end

codec_name ||= version == "1987" ? "ebcdic" : "ascii"

codec = case codec_name
        when "ascii"  then CrystalIso8583::Shared::Codec::ASCII.new
        when "bcd"    then CrystalIso8583::Shared::Codec::BCD.new
        when "ebcdic" then CrystalIso8583::Shared::Codec::EBCDIC.new
        else
          STDERR.puts "Unknown codec: #{codec_name} (expected ascii, bcd, or ebcdic)"
          exit 1
        end

msg = case version
      when "1987"
        m = CrystalIso8583::V1987::Msg0100.new
        m.iso002 = "4349750003416619"   # Primary Account Number (PAN)
        m.iso003 = "000000"             # Processing Code
        m.iso004 = "000000001000"       # Amount, Transaction
        m.iso007 = "0302143124"         # Date and Time, Transmission
        m.iso011 = "171374"             # Systems Trace Audit Number (STAN)
        m.iso012 = "143124"             # Time, Local Transaction
        m.iso013 = "0302"               # Date, Local Transaction
        m.iso014 = "2402"               # Date, Expiration
        m.iso022 = "051"                # Point of Service Entry Mode
        m.iso025 = "00"                 # Point of Service Condition Code
        m.iso032 = "487115"             # Acquiring Institution Identification Code
        m.iso037 = "106113171374"       # Retrieval Reference Number
        m.iso041 = "99999999"           # Card Acceptor Terminal Identification
        m.iso042 = "000000000206535"    # Card Acceptor Identification Code (15 chars)
        m.iso043 = "Revolut*8624*GBR"   # Card Acceptor Name/Location (fixed 40 chars, padded by builder)
        m.iso049 = "978"                # Currency Code, Transaction (EUR)
        m
      when "1993"
        m = CrystalIso8583::V1993::Msg1100.new
        m.iso002 = "4349750003416619"                        # Primary Account Number (PAN)
        m.iso003 = "000000"                                  # Processing Code
        m.iso004 = "000000001000"                            # Amount, Transaction
        m.iso006 = "000000001000"                            # Amount, Cardholder Billing
        m.iso011 = "171374"                                  # System Trace Audit Number (STAN)
        m.iso012 = "210302143124"                            # Date and Time, Local Transaction
        m.iso014 = "2402"                                    # Date, Expiration
        m.iso022 = "100050J00010"                            # POS Data Code
        m.iso023 = "000"                                     # Card Sequence Number
        m.iso024 = "100"                                     # Function Code
        m.iso026 = "6012"                                    # Card Acceptor Business Code (MCC)
        m.iso032 = "487115"                                  # Acquiring Institution Identification Code
        m.iso033 = "12928"                                   # Forwarding Institution Identification Code
        m.iso037 = "106113171374"                            # Retrieval Reference Number
        m.iso038 = "252284"                                  # Approval Code
        m.iso041 = "99999999"                                # Card Acceptor Terminal Identification
        m.iso042 = "000000000206535"                         # Card Acceptor Identification Code (15 chars)
        m.iso043 = "Revolut**8624*\\\\GBR\\             LTU" # Card Acceptor Name/Location
        m.iso049 = "978"                                     # Currency Code, Transaction (EUR)
        m.iso051 = "978"                                     # Currency Code, Cardholder Billing (EUR)
        m.iso063 = "0315481061486847479"                     # Network Data
        m.iso093 = "12928"                                   # Transaction Destination Institution ID
        m.iso094 = "487115"                                  # Transaction Originator Institution ID
        m.iso100 = "00000000000"                             # Receiving Institution Identification Code
        m.iso102 = "500004684881           "                 # Account Identification 1
        m.iso116 = "5900000005"                               # POS Data
        m
      else
        STDERR.puts "Unknown version: #{version} (expected 1987 or 1993)"
        exit 1
      end

output ||= "data/out/msg_#{msg.mti_string}_built.bin"

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
puts "Version     : #{version} (#{msg.mti_string})"
puts "Codec       : #{codec_name}"
puts "ISO message : #{iso_bytes.size} bytes"
puts "Written     : #{payload.size} bytes (#{header_note}) → #{output}"
puts msg.to_json
