module CrystalIso8583
  module V1993
    module DataDictionary
      def self.fields : Hash(Int32, Shared::FieldDescriptor)
        fix = Shared::FieldEncoding::FIXED
        ll = Shared::FieldEncoding::LLVAR
        lll = Shared::FieldEncoding::LLLVAR
        n = Shared::DataType::N
        an = Shared::DataType::AN
        ans = Shared::DataType::ANS
        b = Shared::DataType::B
        z = Shared::DataType::Z

        {
            2 => field_descriptor(2, ll, 19, n, "PAN"),
            3 => field_descriptor(3, fix, 6, n, "Processing Code"),
            4 => field_descriptor(4, fix, 12, n, "Amount, Transaction"),
            5 => field_descriptor(5, fix, 12, n, "Amount, Settlement"),
            6 => field_descriptor(6, fix, 12, n, "Amount, Cardholder Billing"),
            7 => field_descriptor(7, fix, 10, n, "Transmission Date & Time"),
            9 => field_descriptor(9, fix, 8, n, "Conversion Rate, Settlement"),
           10 => field_descriptor(10, fix, 8, n, "Conversion Rate, Cardholder Billing"),
           11 => field_descriptor(11, fix, 6, n, "Systems Trace Audit Number"),
           12 => field_descriptor(12, fix, 12, n, "Date/Time, Local Transaction"),
           13 => field_descriptor(13, fix, 4, n, "Date, Local Transaction"),
           14 => field_descriptor(14, fix, 4, n, "Date, Expiration"),
           15 => field_descriptor(15, fix, 4, n, "Date, Settlement"),
           16 => field_descriptor(16, fix, 4, n, "Date, Conversion"),
           17 => field_descriptor(17, fix, 4, n, "Date, Capture"),
           18 => field_descriptor(18, fix, 4, n, "Merchant Type"),
           19 => field_descriptor(19, fix, 3, n, "Acquiring Institution Country Code"),
           20 => field_descriptor(20, fix, 3, n, "PAN Extended Country Code"),
           21 => field_descriptor(21, fix, 3, n, "Forwarding Institution Country Code"),
           22 => field_descriptor(22, fix, 12, an, "POS Entry Mode"),
           23 => field_descriptor(23, fix, 3, n, "Application PAN Sequence Number"),
           24 => field_descriptor(24, fix, 3, n, "Function Code"),
           25 => field_descriptor(25, fix, 2, n, "POS Condition Code"),
           26 => field_descriptor(26, fix, 4, n, "Merchant Category Code"),
           27 => field_descriptor(27, fix, 1, n, "Authorization ID Response Length"),
           28 => field_descriptor(28, fix, 9, an, "Amount, Transaction Fee"),
           29 => field_descriptor(29, fix, 9, an, "Amount, Settlement Fee"),
           30 => field_descriptor(30, fix, 9, an, "Amount, Transaction Processing Fee"),
           31 => field_descriptor(31, fix, 9, an, "Amount, Settlement Processing Fee"),
           32 => field_descriptor(32, ll, 11, n, "Acquiring Institution ID Code"),
           33 => field_descriptor(33, ll, 11, n, "Forwarding Institution ID Code"),
           35 => field_descriptor(35, ll, 37, z, "Track 2 Data"),
           36 => field_descriptor(36, lll, 104, z, "Track 3 Data"),
           37 => field_descriptor(37, fix, 12, ans, "Retrieval Reference Number"),
           38 => field_descriptor(38, fix, 6, ans, "Authorization ID Response"),
           39 => field_descriptor(39, fix, 2, ans, "Response Code"),
           40 => field_descriptor(40, fix, 3, ans, "Service Restriction Code"),
           41 => field_descriptor(41, fix, 8, ans, "Card Acceptor Terminal ID"),
           42 => field_descriptor(42, fix, 15, ans, "Card Acceptor ID Code"),
           43 => field_descriptor(43, fix, 40, ans, "Card Acceptor Name/Location"),
           44 => field_descriptor(44, ll, 25, ans, "Additional Response Data"),
           45 => field_descriptor(45, ll, 76, ans, "Track 1 Data"),
           46 => field_descriptor(46, lll, 999, ans, "Additional Data - ISO"),
           47 => field_descriptor(47, lll, 999, ans, "Additional Data - National"),
           48 => field_descriptor(48, lll, 999, ans, "Additional Data - Private"),
           49 => field_descriptor(49, fix, 3, n, "Currency Code, Transaction"),
           50 => field_descriptor(50, fix, 3, n, "Currency Code, Settlement"),
           51 => field_descriptor(51, fix, 3, n, "Currency Code, Cardholder Billing"),
           52 => field_descriptor(52, fix, 8, b, "PIN Data"),
           53 => field_descriptor(53, fix, 16, n, "Security Related Control Information"),
           54 => field_descriptor(54, lll, 120, ans, "Additional Amounts"),
           55 => field_descriptor(55, lll, 999, ans, "ICC Data"),
           56 => field_descriptor(56, lll, 999, ans, "Reserved ISO"),
           57 => field_descriptor(57, lll, 999, ans, "Reserved National"),
           58 => field_descriptor(58, lll, 999, ans, "Reserved National"),
           59 => field_descriptor(59, lll, 999, ans, "Reserved National"),
           60 => field_descriptor(60, lll, 999, ans, "Reserved Private"),
           61 => field_descriptor(61, lll, 999, ans, "Reserved Private"),
           62 => field_descriptor(62, lll, 999, ans, "Reserved Private"),
           63 => field_descriptor(63, lll, 999, ans, "Reserved Private"),
           64 => field_descriptor(64, fix, 8, b, "MAC"),
           70 => field_descriptor(70, fix, 3, n, "Network Management Information Code"),
           90 => field_descriptor(90, fix, 42, n, "Original Data Elements"),
           93 => field_descriptor(93, ll, 11, n, "Transaction Destination Institution ID Code"),
           94 => field_descriptor(94, ll, 11, n, "Transaction Originator Institution ID Code"),
           95 => field_descriptor(95, fix, 42, an, "Replacement Amounts"),
          100 => field_descriptor(100, ll, 11, n, "Receiving Institution ID Code"),
          102 => field_descriptor(102, ll, 28, ans, "Account Identification 1"),
          103 => field_descriptor(103, ll, 28, ans, "Account Identification 2"),
          116 => field_descriptor(116, lll, 999, ans, "Reserved Private"),
          128 => field_descriptor(128, fix, 8, b, "MAC 2"),
        }
      end

      private def self.field_descriptor(id, encoding, max_length, data_type, label)
        Shared::FieldDescriptor.new(
          id: id, encoding: encoding, max_length: max_length,
          data_type: data_type, label: label
        )
      end
    end
  end
end
