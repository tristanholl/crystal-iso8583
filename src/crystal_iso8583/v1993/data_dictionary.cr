module CrystalIso8583
  module V1993
    module DataDictionary
      def self.fields : Hash(Int32, Shared::FieldDescriptor)
        f = Shared::FieldEncoding
        d = Shared::DataType

        {
           2 => fd(  2, f::LLVAR,   19, d::N,   "PAN"),
           3 => fd(  3, f::FIXED,    6, d::N,   "Processing Code"),
           4 => fd(  4, f::FIXED,   12, d::N,   "Amount, Transaction"),
           5 => fd(  5, f::FIXED,   12, d::N,   "Amount, Settlement"),
           6 => fd(  6, f::FIXED,   12, d::N,   "Amount, Cardholder Billing"),
           7 => fd(  7, f::FIXED,   10, d::N,   "Transmission Date & Time"),
           9 => fd(  9, f::FIXED,    8, d::N,   "Conversion Rate, Settlement"),
          10 => fd( 10, f::FIXED,    8, d::N,   "Conversion Rate, Cardholder Billing"),
          11 => fd( 11, f::FIXED,    6, d::N,   "Systems Trace Audit Number"),
          12 => fd( 12, f::FIXED,   12, d::N,   "Date/Time, Local Transaction"),
          13 => fd( 13, f::FIXED,    4, d::N,   "Date, Local Transaction"),
          14 => fd( 14, f::FIXED,    4, d::N,   "Date, Expiration"),
          15 => fd( 15, f::FIXED,    4, d::N,   "Date, Settlement"),
          16 => fd( 16, f::FIXED,    4, d::N,   "Date, Conversion"),
          17 => fd( 17, f::FIXED,    4, d::N,   "Date, Capture"),
          18 => fd( 18, f::FIXED,    4, d::N,   "Merchant Type"),
          19 => fd( 19, f::FIXED,    3, d::N,   "Acquiring Institution Country Code"),
          20 => fd( 20, f::FIXED,    3, d::N,   "PAN Extended Country Code"),
          21 => fd( 21, f::FIXED,    3, d::N,   "Forwarding Institution Country Code"),
          22 => fd( 22, f::FIXED,   12, d::AN,  "POS Entry Mode"),
          23 => fd( 23, f::FIXED,    3, d::N,   "Application PAN Sequence Number"),
          24 => fd( 24, f::FIXED,    3, d::N,   "Function Code"),
          25 => fd( 25, f::FIXED,    2, d::N,   "POS Condition Code"),
          26 => fd( 26, f::FIXED,    4, d::N,   "Merchant Category Code"),
          27 => fd( 27, f::FIXED,    1, d::N,   "Authorization ID Response Length"),
          28 => fd( 28, f::FIXED,    9, d::AN,  "Amount, Transaction Fee"),
          29 => fd( 29, f::FIXED,    9, d::AN,  "Amount, Settlement Fee"),
          30 => fd( 30, f::FIXED,    9, d::AN,  "Amount, Transaction Processing Fee"),
          31 => fd( 31, f::FIXED,    9, d::AN,  "Amount, Settlement Processing Fee"),
          32 => fd( 32, f::LLVAR,   11, d::N,   "Acquiring Institution ID Code"),
          33 => fd( 33, f::LLVAR,   11, d::N,   "Forwarding Institution ID Code"),
          35 => fd( 35, f::LLVAR,   37, d::Z,   "Track 2 Data"),
          36 => fd( 36, f::LLLVAR, 104, d::Z,   "Track 3 Data"),
          37 => fd( 37, f::FIXED,   12, d::ANS, "Retrieval Reference Number"),
          38 => fd( 38, f::FIXED,    6, d::ANS, "Authorization ID Response"),
          39 => fd( 39, f::FIXED,    2, d::ANS, "Response Code"),
          40 => fd( 40, f::FIXED,    3, d::ANS, "Service Restriction Code"),
          41 => fd( 41, f::FIXED,    8, d::ANS, "Card Acceptor Terminal ID"),
          42 => fd( 42, f::FIXED,   15, d::ANS, "Card Acceptor ID Code"),
          43 => fd( 43, f::FIXED,   40, d::ANS, "Card Acceptor Name/Location"),
          44 => fd( 44, f::LLVAR,   25, d::ANS, "Additional Response Data"),
          45 => fd( 45, f::LLVAR,   76, d::ANS, "Track 1 Data"),
          46 => fd( 46, f::LLLVAR, 999, d::ANS, "Additional Data - ISO"),
          47 => fd( 47, f::LLLVAR, 999, d::ANS, "Additional Data - National"),
          48 => fd( 48, f::LLLVAR, 999, d::ANS, "Additional Data - Private"),
          49 => fd( 49, f::FIXED,    3, d::N,   "Currency Code, Transaction"),
          50 => fd( 50, f::FIXED,    3, d::N,   "Currency Code, Settlement"),
          51 => fd( 51, f::FIXED,    3, d::N,   "Currency Code, Cardholder Billing"),
          52 => fd( 52, f::FIXED,    8, d::B,   "PIN Data"),
          53 => fd( 53, f::FIXED,   16, d::N,   "Security Related Control Information"),
          54 => fd( 54, f::LLLVAR, 120, d::ANS, "Additional Amounts"),
          55 => fd( 55, f::LLLVAR, 999, d::ANS, "ICC Data"),
          56 => fd( 56, f::LLLVAR, 999, d::ANS, "Reserved ISO"),
          57 => fd( 57, f::LLLVAR, 999, d::ANS, "Reserved National"),
          58 => fd( 58, f::LLLVAR, 999, d::ANS, "Reserved National"),
          59 => fd( 59, f::LLLVAR, 999, d::ANS, "Reserved National"),
          60 => fd( 60, f::LLLVAR, 999, d::ANS, "Reserved Private"),
          61 => fd( 61, f::LLLVAR, 999, d::ANS, "Reserved Private"),
          62 => fd( 62, f::LLLVAR, 999, d::ANS, "Reserved Private"),
          63 => fd( 63, f::LLLVAR, 999, d::ANS, "Reserved Private"),
          64 => fd( 64, f::FIXED,    8, d::B,   "MAC"),
          70 => fd( 70, f::FIXED,    3, d::N,   "Network Management Information Code"),
          90 => fd( 90, f::FIXED,   42, d::N,   "Original Data Elements"),
          93 => fd( 93, f::LLVAR,   11, d::N,   "Transaction Destination Institution ID Code"),
          94 => fd( 94, f::LLVAR,   11, d::N,   "Transaction Originator Institution ID Code"),
          95 => fd( 95, f::FIXED,   42, d::AN,  "Replacement Amounts"),
         100 => fd(100, f::LLVAR,   11, d::N,   "Receiving Institution ID Code"),
         102 => fd(102, f::LLVAR,   28, d::ANS, "Account Identification 1"),
         103 => fd(103, f::LLVAR,   28, d::ANS, "Account Identification 2"),
         116 => fd(116, f::LLLVAR, 999, d::ANS, "Reserved Private"),
         128 => fd(128, f::FIXED,    8, d::B,   "MAC 2"),
        }
      end

      private def self.fd(id, encoding, max_length, data_type, label)
        Shared::FieldDescriptor.new(
          id: id, encoding: encoding, max_length: max_length,
          data_type: data_type, label: label
        )
      end
    end
  end
end
