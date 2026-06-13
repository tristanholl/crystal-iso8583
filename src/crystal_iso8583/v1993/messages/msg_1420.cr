module CrystalIso8583
  module V1993
    class Msg1420 < TypedMessage
      mti "1420"

      field iso002, id: 2, required: true  # Primary Account Number (PAN) — R (repeated)
      field iso003, id: 3, required: true  # Processing Code — R (repeated)
      field iso004, id: 4, required: true  # Amount, Transaction — M
      field iso006, id: 6                  # Amount, Cardholder Billing — C
      field iso007, id: 7, required: true  # Date and Time, Transmission — M
      field iso010, id: 10                 # Conversion Rate, Cardholder Billing — R (repeated)
      field iso011, id: 11, required: true # System Trace Audit Number (STAN) — M
      field iso012, id: 12, required: true # Date and Time, Local Transaction — M
      field iso023, id: 23                 # Card Sequence Number — R (repeated)
      field iso024, id: 24, required: true # Function Code — M
      field iso025, id: 25, required: true # Message Reason Code — M
      field iso030, id: 30                 # Amounts, Original — C
      field iso032, id: 32, required: true # Acquiring Institution Identification Code — R (repeated)
      field iso037, id: 37, required: true # Retrieval Reference Number — R (repeated)
      field iso038, id: 38                 # Approval Code — R (repeated)
      field iso043, id: 43                 # Card Acceptor Name/Location — R (repeated)
      field iso048, id: 48                 # Additional Data - Private — R (repeated)
      field iso049, id: 49                 # Currency Code, Transaction — R (repeated)
      field iso051, id: 51                 # Currency Code, Cardholder Billing — R (repeated)
      field iso053, id: 53                 # Security Related Control Information — C
      field iso054, id: 54                 # Amounts, Additional — C
      field iso056, id: 56, required: true # Original Data Elements — M
      field iso059, id: 59                 # Acquirer Reference Data — = (mirrored)
      field iso064, id: 64                 # MAC Field — C
      field iso095, id: 95                 # Card Issuer Reference Data — O
      field iso111, id: 111                # Encryption Data — C
    end
  end
end
