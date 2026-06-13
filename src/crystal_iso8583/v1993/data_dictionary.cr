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
            2 => fd(2, ll, 19, n, "Primary Account Number (PAN)"),
            3 => fd(3, fix, 6, n, "Processing Code"),
            4 => fd(4, fix, 12, n, "Amount, Transaction"),
            6 => fd(6, fix, 12, n, "Amount, Cardholder Billing"),
            7 => fd(7, fix, 10, n, "Date and Time, Transmission"),
           10 => fd(10, fix, 8, n, "Conversion Rate, Cardholder Billing"),
           11 => fd(11, fix, 6, n, "System Trace Audit Number (STAN)"),
           12 => fd(12, fix, 12, n, "Date and Time, Local Transaction"),
           14 => fd(14, fix, 4, n, "Date, Expiration"),
           22 => fd(22, fix, 12, an, "POS Data Code"),
           23 => fd(23, fix, 3, n, "Card Sequence Number"),
           24 => fd(24, fix, 3, n, "Function Code"),
           25 => fd(25, fix, 4, n, "Message Reason Code"),
           26 => fd(26, fix, 4, n, "Card Acceptor Business Code"),
           30 => fd(30, fix, 24, n, "Amounts, Original"),
           32 => fd(32, ll, 11, n, "Acquiring Institution Identification Code"),
           35 => fd(35, ll, 37, z, "Track 2 Data"),
           37 => fd(37, fix, 12, ans, "Retrieval Reference Number"),
           38 => fd(38, fix, 6, ans, "Approval Code"),
           39 => fd(39, fix, 3, n, "Action Code"),
           41 => fd(41, fix, 8, ans, "Card Acceptor Terminal Identification"),
           42 => fd(42, fix, 15, ans, "Card Acceptor Identification Code"),
           43 => fd(43, ll, 56, ans, "Card Acceptor Name/Location"),
           48 => fd(48, lll, 999, ans, "Additional Data - Private"),
           49 => fd(49, fix, 3, n, "Currency Code, Transaction"),
           51 => fd(51, fix, 3, n, "Currency Code, Cardholder Billing"),
           52 => fd(52, fix, 8, b, "Personal Identification Number (PIN) Data"),
           53 => fd(53, ll, 48, b, "Security Related Control Information"),
           54 => fd(54, lll, 120, ans, "Amounts, Additional"),
           55 => fd(55, lll, 255, b, "Integrated Circuit Card (ICC) System Related Data"),
           56 => fd(56, ll, 35, n, "Original Data Elements"),
           57 => fd(57, fix, 3, n, "Authorisation Life Cycle Code"),
           58 => fd(58, ll, 11, n, "Authorising Agent Institution Identification Code"),
           59 => fd(59, lll, 100, ans, "Acquirer Reference Data (Transport Data)"),
           62 => fd(62, lll, 999, ans, "e-Payment and MOTO Data"),
           64 => fd(64, fix, 8, b, "Message Authentication Code (MAC) Field"),
           93 => fd(93, ll, 5, n, "Transaction Destination Institution Identification Code"),
           94 => fd(94, ll, 5, n, "Transaction Originator Identification Code"),
           95 => fd(95, ll, 99, ans, "Card Issuer Reference Data"),
          111 => fd(111, llll, 9999, b, "Encryption Data"),
          128 => fd(128, fix, 8, b, "Message Authentication Code (MAC) Field"),
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
