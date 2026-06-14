module CrystalIso8583
  module V1993
    class Msg1100 < TypedMessage
      mti "1100"

      field iso002, id: 2, required: true  # Primary Account Number (PAN) — M
      field iso003, id: 3, required: true  # Processing Code — M
      field iso004, id: 4                  # Amount, Transaction — C
      field iso006, id: 6                  # Amount, Cardholder Billing — C
      field iso007, id: 7, required: true  # Date and Time, Transmission — M
      field iso010, id: 10                 # Conversion Rate, Cardholder Billing — C
      field iso011, id: 11, required: true # System Trace Audit Number (STAN) — M
      field iso012, id: 12, required: true # Date and Time, Local Transaction — M
      field iso014, id: 14                 # Date, Expiration — C
      field iso022, id: 22, required: true # POS Data Code — M
      field iso023, id: 23                 # Card Sequence Number — C
      field iso024, id: 24, required: true # Function Code — M
      field iso025, id: 25                 # Message Reason Code — C
      field iso026, id: 26, required: true # Card Acceptor Business Code — M
      field iso030, id: 30                 # Amounts, Original — C
      field iso032, id: 32, required: true # Acquiring Institution Identification Code — M
      field iso033, id: 33                 # Forwarding Institution Identification Code — C
      field iso035, id: 35                 # Track 2 Data — C
      field iso037, id: 37, required: true # Retrieval Reference Number — M
      field iso038, id: 38                 # Approval Code — C
      field iso039, id: 39                 # Action Code — C
      field iso041, id: 41, required: true # Card Acceptor Terminal Identification — M
      field iso042, id: 42, required: true # Card Acceptor Identification Code — M
      field iso043, id: 43, required: true # Card Acceptor Name/Location — M
      field iso048, id: 48                 # Additional Data - Private — C
      field iso049, id: 49                 # Currency Code, Transaction — C
      field iso051, id: 51                 # Currency Code, Cardholder Billing — C
      field iso052, id: 52                 # PIN Data — C
      field iso053, id: 53                 # Security Related Control Information — C
      field iso054, id: 54                 # Amounts, Additional — C
      field iso055, id: 55                 # ICC System Related Data — C
      field iso057, id: 57                 # Authorisation Life Cycle Code — C
      field iso059, id: 59                 # Acquirer Reference Data — O
      field iso062, id: 62                 # e-Payment and MOTO Data — C
      field iso063, id: 63                 # Network Data — C
      field iso064, id: 64                 # MAC Field — C
      field iso093, id: 93                 # Transaction Destination Institution Identification Code — C
      field iso094, id: 94                 # Transaction Originator Institution Identification Code — C
      field iso100, id: 100                # Receiving Institution Identification Code — C
      field iso102, id: 102                # Account Identification 1 — C
      field iso111, id: 111                # Encryption Data — C
      field iso116, id: 116                # POS Data — C
    end
  end
end
