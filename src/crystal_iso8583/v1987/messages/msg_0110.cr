module CrystalIso8583
  module V1987
    class Msg0110 < TypedMessage
      mti "0110"

      field iso002, id: 2                  # Primary Account Number (PAN) — C (mirrored)
      field iso003, id: 3, required: true  # Processing Code — M (mirrored)
      field iso004, id: 4, required: true  # Amount, Transaction — M (mirrored)
      field iso005, id: 5                  # Amount, Settlement — C
      field iso006, id: 6                  # Amount, Cardholder Billing — C
      field iso007, id: 7, required: true  # Date and Time, Transmission — M (mirrored)
      field iso009, id: 9                  # Conversion Rate, Settlement — C
      field iso010, id: 10                 # Conversion Rate, Cardholder Billing — C
      field iso011, id: 11, required: true # Systems Trace Audit Number — M (mirrored)
      field iso012, id: 12                 # Time, Local Transaction — C (mirrored)
      field iso013, id: 13                 # Date, Local Transaction — C (mirrored)
      field iso014, id: 14                 # Date, Expiration — C
      field iso018, id: 18                 # Merchant Type — C
      field iso022, id: 22                 # Point of Service Entry Mode — C (mirrored)
      field iso023, id: 23                 # Application PAN Sequence Number — C
      field iso024, id: 24                 # Network International Identifier — C
      field iso025, id: 25                 # Point of Service Condition Code — C (mirrored)
      field iso032, id: 32                 # Acquiring Institution Identification Code — C
      field iso033, id: 33                 # Forwarding Institution Identification Code — C
      field iso037, id: 37                 # Retrieval Reference Number — C
      field iso038, id: 38                 # Authorization Identification Response — C
      field iso039, id: 39, required: true # Response Code — M
      field iso041, id: 41, required: true # Card Acceptor Terminal Identification — M (mirrored)
      field iso042, id: 42, required: true # Card Acceptor Identification Code — M (mirrored)
      field iso043, id: 43                 # Card Acceptor Name/Location — C
      field iso044, id: 44                 # Additional Response Data — C
      field iso048, id: 48                 # Additional Data - Private — C
      field iso049, id: 49, required: true # Currency Code, Transaction — M (mirrored)
      field iso050, id: 50                 # Currency Code, Settlement — C
      field iso051, id: 51                 # Currency Code, Cardholder Billing — C
      field iso053, id: 53                 # Security Related Control Information — C
      field iso054, id: 54                 # Amounts, Additional — C
      field iso060, id: 60                 # Reserved for Private Use — O
      field iso061, id: 61                 # Reserved for Private Use — O
      field iso062, id: 62                 # Reserved for Private Use — O
      field iso063, id: 63                 # Reserved for Private Use — O
      field iso064, id: 64                 # Message Authentication Code Field — C
      field iso123, id: 123                # Reserved for Private Use — O
    end
  end
end
