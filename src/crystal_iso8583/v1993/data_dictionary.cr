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
          2 => fd(2, ll, 19, n, "PAN"),
          3 => fd(3, fix, 6, n, "Processing Code"),
          4 => fd(4, fix, 12, n, "Amount, Transaction"),
          5 => fd(5, fix, 12, n, "Amount, Settlement"),
          6 => fd(6, fix, 12, n, "Amount, Cardholder Billing"),
          7 => fd(7, fix, 10, n, "Transmission Date & Time"),
          9 => fd(9, fix, 8, n, "Conversion Rate, Settlement"),
          10 => fd(10, fix, 8, n, "Conversion Rate, Cardholder Billing"),
          11 => fd(11, fix, 6, n, "Systems Trace Audit Number"),
          12 => fd(12, fix, 12, n, "Date/Time, Local Transaction"),
          13 => fd(13, fix, 4, n, "Date, Local Transaction"),
          14 => fd(14, fix, 4, n, "Date, Expiration"),
          15 => fd(15, fix, 4, n, "Date, Settlement"),
          16 => fd(16, fix, 4, n, "Date, Conversion"),
          17 => fd(17, fix, 4, n, "Date, Capture"),
          18 => fd(18, fix, 4, n, "Merchant Type"),
          19 => fd(19, fix, 3, n, "Acquiring Institution Country Code"),
          20 => fd(20, fix, 3, n, "PAN Extended Country Code"),
          21 => fd(21, fix, 3, n, "Forwarding Institution Country Code"),
          22 => fd(22, fix, 12, an, "POS Entry Mode"),
          23 => fd(23, fix, 3, n, "Application PAN Sequence Number"),
          24 => fd(24, fix, 3, n, "Function Code"),
          25 => fd(25, fix, 2, n, "POS Condition Code"),
          26 => fd(26, fix, 4, n, "Merchant Category Code"),
          27 => fd(27, fix, 1, n, "Authorization ID Response Length"),
          28 => fd(28, fix, 9, an, "Amount, Transaction Fee"),
          29 => fd(29, fix, 9, an, "Amount, Settlement Fee"),
          30 => fd(30, fix, 9, an, "Amount, Transaction Processing Fee"),
          31 => fd(31, fix, 9, an, "Amount, Settlement Processing Fee"),
          32 => fd(32, ll, 11, n, "Acquiring Institution ID Code"),
          33 => fd(33, ll, 11, n, "Forwarding Institution ID Code"),
          35 => fd(35, ll, 37, z, "Track 2 Data"),
          36 => fd(36, lll, 104, z, "Track 3 Data"),
          37 => fd(37, fix, 12, ans, "Retrieval Reference Number"),
          38 => fd(38, fix, 6, ans, "Authorization ID Response"),
          39 => fd(39, fix, 2, ans, "Response Code"),
          40 => fd(40, fix, 3, ans, "Service Restriction Code"),
          41 => fd(41, fix, 8, ans, "Card Acceptor Terminal ID"),
          42 => fd(42, fix, 15, ans, "Card Acceptor ID Code"),
          43 => fd(43, fix, 40, ans, "Card Acceptor Name/Location"),
          44 => fd(44, ll, 25, ans, "Additional Response Data"),
          45 => fd(45, ll, 76, ans, "Track 1 Data"),
          46 => fd(46, lll, 999, ans, "Additional Data - ISO"),
          47 => fd(47, lll, 999, ans, "Additional Data - National"),
          48 => fd(48, lll, 999, ans, "Additional Data - Private"),
          49 => fd(49, fix, 3, n, "Currency Code, Transaction"),
          50 => fd(50, fix, 3, n, "Currency Code, Settlement"),
          51 => fd(51, fix, 3, n, "Currency Code, Cardholder Billing"),
          52 => fd(52, fix, 8, b, "PIN Data"),
          53 => fd(53, fix, 16, n, "Security Related Control Information"),
          54 => fd(54, lll, 120, ans, "Additional Amounts"),
          55 => fd(55, lll, 999, ans, "ICC Data"),
          56 => fd(56, lll, 999, ans, "Reserved ISO"),
          57 => fd(57, lll, 999, ans, "Reserved National"),
          58 => fd(58, lll, 999, ans, "Reserved National"),
          59 => fd(59, lll, 999, ans, "Reserved National"),
          60 => fd(60, lll, 999, ans, "Reserved Private"),
          61 => fd(61, lll, 999, ans, "Reserved Private"),
          62 => fd(62, lll, 999, ans, "Reserved Private"),
          63 => fd(63, lll, 999, ans, "Reserved Private"),
          64 => fd(64, fix, 8, b, "MAC"),
          70 => fd(70, fix, 3, n, "Network Management Information Code"),
          90 => fd(90, fix, 42, n, "Original Data Elements"),
          93 => fd(93, ll, 11, n, "Transaction Destination Institution ID Code"),
          94 => fd(94, ll, 11, n, "Transaction Originator Institution ID Code"),
          95 => fd(95, fix, 42, an, "Replacement Amounts"),
          100 => fd(100, ll, 11, n, "Receiving Institution ID Code"),
          102 => fd(102, ll, 28, ans, "Account Identification 1"),
          103 => fd(103, ll, 28, ans, "Account Identification 2"),
          116 => fd(116, lll, 999, ans, "Reserved Private"),
          128 => fd(128, fix, 8, b, "MAC 2"),
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
