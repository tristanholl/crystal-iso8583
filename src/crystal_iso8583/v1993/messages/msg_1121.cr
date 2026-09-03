module CrystalISO8583
  module V1993
    # Authorisation Advice Repeat — identical field set to Msg1120.
    # Spec: "Advice Repeats are identical to the respective Advices with
    # exception of the MTID and the values of BMP 53 and BMP 64 or BMP 128."
    class Msg1121 < TypedMessage
      mti "1121"

      field iso002, id: 2                  # Primary Account Number (PAN) — R (repeated)
      field iso003, id: 3, required: true  # Processing Code — M
      field iso004, id: 4, required: true  # Amount, Transaction — M
      field iso006, id: 6                  # Amount, Cardholder Billing — C
      field iso007, id: 7                  # Date and Time, Transmission — C
      field iso010, id: 10                 # Conversion Rate, Cardholder Billing — C
      field iso011, id: 11, required: true # System Trace Audit Number (STAN) — M
      field iso012, id: 12, required: true # Date and Time, Local Transaction — M
      field iso014, id: 14                 # Date, Expiration — R (repeated)
      field iso023, id: 23                 # Card Sequence Number — C
      field iso024, id: 24, required: true # Function Code — M
      field iso030, id: 30                 # Amounts, Original — C
      field iso032, id: 32                 # Acquiring Institution Identification Code — R (repeated)
      field iso037, id: 37                 # Retrieval Reference Number — R (repeated)
      field iso038, id: 38                 # Approval Code — R (repeated)
      field iso041, id: 41, required: true # Card Acceptor Terminal Identification — M
      field iso042, id: 42, required: true # Card Acceptor Identification Code — M
      field iso043, id: 43                 # Card Acceptor Name/Location — R (repeated)
      field iso048, id: 48                 # Additional Data - Private — R (repeated)
      field iso049, id: 49                 # Currency Code, Transaction — R (repeated)
      field iso051, id: 51                 # Currency Code, Cardholder Billing — R (repeated)
      field iso053, id: 53                 # Security Related Control Information — C
      field iso054, id: 54                 # Amounts, Additional — C
      field iso056, id: 56, required: true # Original Data Elements — M
      field iso059, id: 59                 # Acquirer Reference Data — O
      field iso064, id: 64                 # MAC Field — C
      field iso095, id: 95                 # Card Issuer Reference Data — O
      field iso111, id: 111                # Encryption Data — C
    end
  end
end
