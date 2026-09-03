module CrystalISO8583
  module V1993
    class Msg1110 < TypedMessage
      mti "1110"

      field iso002, id: 2                  # Primary Account Number (PAN) — = (mirrored)
      field iso003, id: 3                  # Processing Code — = (mirrored)
      field iso004, id: 4                  # Amount, Transaction — C
      field iso006, id: 6                  # Amount, Cardholder Billing — C
      field iso007, id: 7                  # Date and Time, Transmission — C
      field iso010, id: 10                 # Conversion Rate, Cardholder Billing — = (mirrored)
      field iso011, id: 11                 # System Trace Audit Number (STAN) — = (mirrored)
      field iso012, id: 12                 # Date and Time, Local Transaction — = (mirrored)
      field iso030, id: 30                 # Amounts, Original — C
      field iso032, id: 32                 # Acquiring Institution Identification Code — = (mirrored)
      field iso037, id: 37                 # Retrieval Reference Number — = (mirrored)
      field iso038, id: 38                 # Approval Code — C
      field iso039, id: 39, required: true # Action Code — M
      field iso041, id: 41                 # Card Acceptor Terminal Identification — = (mirrored)
      field iso042, id: 42                 # Card Acceptor Identification Code — = (mirrored)
      field iso049, id: 49                 # Currency Code, Transaction — = (mirrored)
      field iso051, id: 51                 # Currency Code, Cardholder Billing — = (mirrored)
      field iso053, id: 53                 # Security Related Control Information — C
      field iso054, id: 54                 # Amounts, Additional — C
      field iso055, id: 55                 # ICC System Related Data — C
      field iso058, id: 58                 # Authorising Agent Institution ID Code — O
      field iso059, id: 59                 # Acquirer Reference Data — = (mirrored)
      field iso064, id: 64                 # MAC Field — C
      field iso095, id: 95                 # Card Issuer Reference Data — C
      field iso111, id: 111                # Encryption Data — C
    end
  end
end
