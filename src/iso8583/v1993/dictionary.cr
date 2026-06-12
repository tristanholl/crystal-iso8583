module ISO8583
  module V1993
    # ISO 8583:1993 data element dictionary.
    #
    # Differences from the 1987 edition:
    #   - MTI version digit is 1 (1100, 1110, 1120, 1130) instead of 0
    #   - MTI is wire-encoded as 4 ASCII bytes instead of 2 BCD bytes
    #   - DE 28-31 changed from AN to N type (amount fee fields)
    #   - DE 55 (ICC/EMV data) is formally standardised (same definition in practice)
    #   - DE 56 reserved for private use in 1993; DE 57-63 remain national/private
    #
    # All other field definitions are carried over unchanged from 1987.
    module Dictionary
      FD = Shared::FieldDefinition
      DT = Shared::DataType
      LT = Shared::LengthType

      FIELDS = {
        2  => FD.new(2,  "Primary Account Number",                        DT::N,   LT::LLVAR,  19),
        3  => FD.new(3,  "Processing Code",                               DT::N,   LT::Fixed,  6),
        4  => FD.new(4,  "Amount, Transaction",                           DT::N,   LT::Fixed,  12),
        5  => FD.new(5,  "Amount, Settlement",                            DT::N,   LT::Fixed,  12),
        6  => FD.new(6,  "Amount, Cardholder Billing",                    DT::N,   LT::Fixed,  12),
        7  => FD.new(7,  "Transmission Date and Time",                    DT::N,   LT::Fixed,  10),
        8  => FD.new(8,  "Amount, Cardholder Billing Fee",                DT::N,   LT::Fixed,  8),
        9  => FD.new(9,  "Conversion Rate, Settlement",                   DT::N,   LT::Fixed,  8),
        10 => FD.new(10, "Conversion Rate, Cardholder Billing",           DT::N,   LT::Fixed,  8),
        11 => FD.new(11, "System Trace Audit Number",                     DT::N,   LT::Fixed,  6),
        12 => FD.new(12, "Time, Local Transaction",                       DT::N,   LT::Fixed,  6),
        13 => FD.new(13, "Date, Local Transaction",                       DT::N,   LT::Fixed,  4),
        14 => FD.new(14, "Date, Expiration",                              DT::N,   LT::Fixed,  4),
        15 => FD.new(15, "Date, Settlement",                              DT::N,   LT::Fixed,  4),
        16 => FD.new(16, "Date, Conversion",                              DT::N,   LT::Fixed,  4),
        17 => FD.new(17, "Date, Capture",                                 DT::N,   LT::Fixed,  4),
        18 => FD.new(18, "Merchant Type",                                 DT::N,   LT::Fixed,  4),
        19 => FD.new(19, "Acquiring Institution Country Code",            DT::N,   LT::Fixed,  3),
        20 => FD.new(20, "PAN Extended Country Code",                     DT::N,   LT::Fixed,  3),
        21 => FD.new(21, "Forwarding Institution Country Code",           DT::N,   LT::Fixed,  3),
        22 => FD.new(22, "Point of Service Entry Mode",                   DT::N,   LT::Fixed,  3),
        23 => FD.new(23, "Card Sequence Number",                          DT::N,   LT::Fixed,  3),
        24 => FD.new(24, "Network International Identifier",              DT::N,   LT::Fixed,  3),
        25 => FD.new(25, "Point of Service Condition Code",               DT::N,   LT::Fixed,  2),
        26 => FD.new(26, "Point of Service PIN Capture Code",             DT::N,   LT::Fixed,  2),
        27 => FD.new(27, "Authorizing ID Response Length",                DT::N,   LT::Fixed,  1),
        # DE 28-31: changed to N type in 1993 (were AN in 1987)
        28 => FD.new(28, "Amount, Transaction Fee",                       DT::N,   LT::Fixed,  8),
        29 => FD.new(29, "Amount, Settlement Fee",                        DT::N,   LT::Fixed,  8),
        30 => FD.new(30, "Amount, Transaction Processing Fee",            DT::N,   LT::Fixed,  8),
        31 => FD.new(31, "Amount, Settlement Processing Fee",             DT::N,   LT::Fixed,  8),
        32 => FD.new(32, "Acquiring Institution ID Code",                 DT::N,   LT::LLVAR,  11),
        33 => FD.new(33, "Forwarding Institution ID Code",                DT::N,   LT::LLVAR,  11),
        34 => FD.new(34, "Primary Account Number, Extended",              DT::N,   LT::LLVAR,  28),
        35 => FD.new(35, "Track 2 Data",                                  DT::Z,   LT::LLVAR,  37),
        36 => FD.new(36, "Track 3 Data",                                  DT::Z,   LT::LLLVAR, 104),
        37 => FD.new(37, "Retrieval Reference Number",                    DT::AN,  LT::Fixed,  12),
        38 => FD.new(38, "Authorization Identification Response",         DT::AN,  LT::Fixed,  6),
        39 => FD.new(39, "Response Code",                                 DT::AN,  LT::Fixed,  2),
        40 => FD.new(40, "Service Restriction Code",                      DT::AN,  LT::Fixed,  3),
        41 => FD.new(41, "Card Acceptor Terminal Identification",         DT::ANS, LT::Fixed,  8),
        42 => FD.new(42, "Card Acceptor Identification Code",             DT::ANS, LT::Fixed,  15),
        43 => FD.new(43, "Card Acceptor Name/Location",                   DT::ANS, LT::Fixed,  40),
        44 => FD.new(44, "Additional Response Data",                      DT::AN,  LT::LLVAR,  25),
        45 => FD.new(45, "Track 1 Data",                                  DT::ANS, LT::LLVAR,  76),
        46 => FD.new(46, "Additional Data, ISO",                          DT::ANS, LT::LLLVAR, 999),
        47 => FD.new(47, "Additional Data, National",                     DT::ANS, LT::LLLVAR, 999),
        48 => FD.new(48, "Additional Data, Private",                      DT::ANS, LT::LLLVAR, 999),
        49 => FD.new(49, "Currency Code, Transaction",                    DT::N,   LT::Fixed,  3),
        50 => FD.new(50, "Currency Code, Settlement",                     DT::N,   LT::Fixed,  3),
        51 => FD.new(51, "Currency Code, Cardholder Billing",             DT::N,   LT::Fixed,  3),
        52 => FD.new(52, "Personal Identification Number Data",           DT::B,   LT::Fixed,  8),
        53 => FD.new(53, "Security Related Control Information",          DT::N,   LT::Fixed,  16),
        54 => FD.new(54, "Additional Amounts",                            DT::ANS, LT::LLLVAR, 120),
        55 => FD.new(55, "ICC Data",                                      DT::B,   LT::LLLVAR, 255),
        56 => FD.new(56, "Reserved ISO 1",                                DT::ANS, LT::LLLVAR, 999),
        57 => FD.new(57, "Reserved National 1",                           DT::ANS, LT::LLLVAR, 999),
        58 => FD.new(58, "Reserved National 2",                           DT::ANS, LT::LLLVAR, 999),
        59 => FD.new(59, "Reserved National 3",                           DT::ANS, LT::LLLVAR, 999),
        60 => FD.new(60, "Reserved National 4",                           DT::ANS, LT::LLLVAR, 999),
        61 => FD.new(61, "Reserved Private 1",                            DT::ANS, LT::LLLVAR, 999),
        62 => FD.new(62, "Reserved Private 2",                            DT::ANS, LT::LLLVAR, 999),
        63 => FD.new(63, "Reserved Private 3",                            DT::ANS, LT::LLLVAR, 999),
        64 => FD.new(64, "Message Authentication Code",                   DT::B,   LT::Fixed,  8),
        65 => FD.new(65, "Extended Bitmap Indicator",                     DT::B,   LT::Fixed,  8),
        66 => FD.new(66, "Settlement Code",                               DT::N,   LT::Fixed,  1),
        70 => FD.new(70, "Network Management Information Code",           DT::N,   LT::Fixed,  3),
        90 => FD.new(90, "Original Data Elements",                        DT::N,   LT::Fixed,  42),
        95 => FD.new(95, "Replacement Amounts",                           DT::AN,  LT::Fixed,  42),
        96 => FD.new(96, "Message Security Code",                         DT::B,   LT::Fixed,  8),
        100 => FD.new(100, "Receiving Institution ID Code",               DT::N,   LT::LLVAR,  11),
        102 => FD.new(102, "Account Identification 1",                    DT::ANS, LT::LLVAR,  28),
        103 => FD.new(103, "Account Identification 2",                    DT::ANS, LT::LLVAR,  28),
        128 => FD.new(128, "Extended Message Authentication Code",        DT::B,   LT::Fixed,  8),
      } of Int32 => Shared::FieldDefinition

      def self.lookup(field_num : Int32) : Shared::FieldDefinition?
        FIELDS[field_num]?
      end
    end
  end
end
