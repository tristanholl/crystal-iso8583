module CrystalIso8583
  module V1993
    module DataDictionary
      def self.fields : Hash(Int32, Shared::FieldDescriptor)
        fix = Shared::FieldEncoding::FIXED
        ll = Shared::FieldEncoding::LLVAR
        lll = Shared::FieldEncoding::LLLVAR
        llll = Shared::FieldEncoding::LLLLVAR
        n = Shared::DataType::N
        an = Shared::DataType::AN
        ans = Shared::DataType::ANS
        b = Shared::DataType::B
        z = Shared::DataType::Z

        {
            2 => field_descriptor(2, ll, 19, n, "Primary Account Number (PAN)"),
            3 => field_descriptor(3, fix, 6, n, "Processing Code"),
            4 => field_descriptor(4, fix, 12, n, "Amount, Transaction"),
            6 => field_descriptor(6, fix, 12, n, "Amount, Cardholder Billing"),
            7 => field_descriptor(7, fix, 10, n, "Date and Time, Transmission"),
           10 => field_descriptor(10, fix, 8, n, "Conversion Rate, Cardholder Billing"),
           11 => field_descriptor(11, fix, 6, n, "System Trace Audit Number (STAN)"),
           12 => field_descriptor(12, fix, 12, n, "Date and Time, Local Transaction"),
           14 => field_descriptor(14, fix, 4, n, "Date, Expiration"),
           22 => field_descriptor(22, fix, 12, an, "POS Data Code"),
           23 => field_descriptor(23, fix, 3, n, "Card Sequence Number"),
           24 => field_descriptor(24, fix, 3, n, "Function Code"),
           25 => field_descriptor(25, fix, 4, n, "Message Reason Code"),
           26 => field_descriptor(26, fix, 4, n, "Card Acceptor Business Code"),
           30 => field_descriptor(30, fix, 24, n, "Amounts, Original"),
           32 => field_descriptor(32, ll, 11, n, "Acquiring Institution Identification Code"),
           33 => field_descriptor(33, ll, 11, n, "Forwarding Institution Identification Code"),
           35 => field_descriptor(35, ll, 37, z, "Track 2 Data"),
           37 => field_descriptor(37, fix, 12, ans, "Retrieval Reference Number"),
           38 => field_descriptor(38, fix, 6, ans, "Authorization ID Response"),
           39 => field_descriptor(39, fix, 2, ans, "Response Code"),
           40 => field_descriptor(40, fix, 3, ans, "Service Restriction Code"),
           41 => field_descriptor(41, fix, 8, ans, "Card Acceptor Terminal ID"),
           42 => field_descriptor(42, fix, 15, ans, "Card Acceptor ID Code"),
           43 => field_descriptor(43, ll,  56, ans, "Card Acceptor Name/Location"),
           44 => field_descriptor(44, ll, 25, ans, "Additional Response Data"),
           45 => field_descriptor(45, ll, 76, ans, "Track 1 Data"),
           46 => field_descriptor(46, lll, 999, ans, "Additional Data - ISO"),
           47 => field_descriptor(47, lll, 999, ans, "Additional Data - National"),
           48 => field_descriptor(48, lll, 999, ans, "Additional Data - Private"),
           49 => field_descriptor(49, fix, 3, n, "Currency Code, Transaction"),
           51 => field_descriptor(51, fix, 3, n, "Currency Code, Cardholder Billing"),
           52 => field_descriptor(52, fix, 8, b, "Personal Identification Number (PIN) Data"),
           53 => field_descriptor(53, ll, 48, b, "Security Related Control Information"),
           54 => field_descriptor(54, lll, 120, ans, "Amounts, Additional"),
           55 => field_descriptor(55, lll, 255, b, "Integrated Circuit Card (ICC) System Related Data"),
           56 => field_descriptor(56, ll, 35, n, "Original Data Elements"),
           57 => field_descriptor(57, fix, 3, n, "Authorisation Life Cycle Code"),
           58 => field_descriptor(58, ll, 11, n, "Authorising Agent Institution Identification Code"),
           59 => field_descriptor(59, lll, 100, ans, "Acquirer Reference Data (Transport Data)"),
           62 => field_descriptor(62, lll, 999, ans, "e-Payment and MOTO Data"),
           63 => field_descriptor(63, lll, 999, ans, "Network Data"),
           64 => field_descriptor(64, fix, 8, b, "Message Authentication Code (MAC) Field"),
           93 => field_descriptor(93, ll, 5, n, "Transaction Destination Institution Identification Code"),
           94 => field_descriptor(94, ll, 5, n, "Transaction Originator Identification Code"),
           95 => field_descriptor(95, ll, 99, ans, "Card Issuer Reference Data"),
          100 => field_descriptor(100, ll, 11, n, "Receiving Institution Identification Code"),
          102 => field_descriptor(102, ll, 28, ans, "Account Identification 1"),
          111 => field_descriptor(111, llll, 9999, b, "Encryption Data"),
          116 => field_descriptor(116, lll, 999, ans, "POS Data"),
          128 => field_descriptor(128, fix, 8, b, "Message Authentication Code (MAC) Field"),
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
