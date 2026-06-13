module CrystalIso8583
  module V1993
    class Msg1430 < TypedMessage
      mti "1430"

      field iso003, id: 3                  # Processing Code — R (repeated)
      field iso004, id: 4                  # Amount, Transaction — = (mirrored)
      field iso006, id: 6                  # Amount, Cardholder Billing — = (mirrored)
      field iso007, id: 7, required: true  # Date and Time, Transmission — M
      field iso011, id: 11                 # System Trace Audit Number (STAN) — = (mirrored)
      field iso012, id: 12                 # Date and Time, Local Transaction — = (mirrored)
      field iso032, id: 32                 # Acquiring Institution Identification Code — = (mirrored)
      field iso037, id: 37                 # Retrieval Reference Number — = (mirrored)
      field iso038, id: 38                 # Approval Code — = (mirrored)
      field iso039, id: 39, required: true # Action Code — M
      field iso049, id: 49                 # Currency Code, Transaction — = (mirrored)
      field iso051, id: 51                 # Currency Code, Cardholder Billing — = (mirrored)
      field iso053, id: 53                 # Security Related Control Information — C
      field iso056, id: 56                 # Original Data Elements — = (mirrored)
      field iso059, id: 59                 # Acquirer Reference Data — = (mirrored)
      field iso064, id: 64                 # MAC Field — C
      field iso095, id: 95                 # Card Issuer Reference Data — C
      field iso111, id: 111                # Encryption Data — C
    end
  end
end
