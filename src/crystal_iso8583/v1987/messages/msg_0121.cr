module CrystalISO8583
  module V1987
    # Authorization Advice Repeat — identical field set to Msg0120.
    # Repeats are identical to the respective advice with the exception of
    # the MTI and the values of BMP 53 and BMP 64.
    class Msg0121 < TypedMessage
      mti "0121"

      field iso002, id: 2, required: true  # Primary Account Number (PAN) — M
      field iso003, id: 3, required: true  # Processing Code — M
      field iso004, id: 4, required: true  # Amount, Transaction — M
      field iso006, id: 6                  # Amount, Cardholder Billing — C
      field iso007, id: 7, required: true  # Date and Time, Transmission — M
      field iso009, id: 9                  # Conversion Rate, Settlement — C
      field iso010, id: 10                 # Conversion Rate, Cardholder Billing — C
      field iso011, id: 11, required: true # Systems Trace Audit Number — M
      field iso012, id: 12, required: true # Time, Local Transaction — M
      field iso013, id: 13, required: true # Date, Local Transaction — M
      field iso014, id: 14                 # Date, Expiration — C
      field iso018, id: 18                 # Merchant Type — C
      field iso022, id: 22                 # Point of Service Entry Mode — C
      field iso023, id: 23                 # Application PAN Sequence Number — C
      field iso024, id: 24                 # Network International Identifier — C
      field iso025, id: 25                 # Point of Service Condition Code — C
      field iso032, id: 32                 # Acquiring Institution Identification Code — C
      field iso033, id: 33                 # Forwarding Institution Identification Code — C
      field iso035, id: 35                 # Track 2 Data — C
      field iso037, id: 37                 # Retrieval Reference Number — C
      field iso038, id: 38                 # Authorization Identification Response — C
      field iso039, id: 39                 # Response Code — C
      field iso041, id: 41, required: true # Card Acceptor Terminal Identification — M
      field iso042, id: 42, required: true # Card Acceptor Identification Code — M
      field iso043, id: 43                 # Card Acceptor Name/Location — C
      field iso048, id: 48                 # Additional Data - Private — C
      field iso049, id: 49, required: true # Currency Code, Transaction — M
      field iso051, id: 51                 # Currency Code, Cardholder Billing — C
      field iso053, id: 53                 # Security Related Control Information — C
      field iso054, id: 54                 # Amounts, Additional — C
      field iso064, id: 64                 # Message Authentication Code Field — C
      field iso090, id: 90, required: true # Original Data Elements — M
      field iso123, id: 123                # Reserved for Private Use — O
    end
  end
end
