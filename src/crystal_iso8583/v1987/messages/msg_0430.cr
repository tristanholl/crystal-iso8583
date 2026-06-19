module CrystalIso8583
  module V1987
    class Msg0430 < TypedMessage
      mti "0430"

      field iso003, id: 3                  # Processing Code — C (mirrored)
      field iso004, id: 4                  # Amount, Transaction — C (mirrored)
      field iso006, id: 6                  # Amount, Cardholder Billing — C (mirrored)
      field iso007, id: 7                  # Date and Time, Transmission — C
      field iso011, id: 11, required: true # Systems Trace Audit Number — M (mirrored)
      field iso012, id: 12, required: true # Time, Local Transaction — M (mirrored)
      field iso013, id: 13, required: true # Date, Local Transaction — M (mirrored)
      field iso032, id: 32                 # Acquiring Institution Identification Code — C (mirrored)
      field iso037, id: 37                 # Retrieval Reference Number — C (mirrored)
      field iso038, id: 38                 # Authorization Identification Response — C (mirrored)
      field iso039, id: 39, required: true # Response Code — M
      field iso049, id: 49                 # Currency Code, Transaction — C (mirrored)
      field iso051, id: 51                 # Currency Code, Cardholder Billing — C (mirrored)
      field iso053, id: 53                 # Security Related Control Information — C
      field iso064, id: 64                 # Message Authentication Code Field — C
      field iso090, id: 90, required: true # Original Data Elements — M
      field iso123, id: 123                # Reserved for Private Use — O
    end
  end
end
