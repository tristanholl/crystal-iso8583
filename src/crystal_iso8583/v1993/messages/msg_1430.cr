module CrystalIso8583
  module V1993
    class Msg1430 < TypedMessage
      mti "1430"

      field iso002, id: 2                  # PAN
      field iso003, id: 3, required: true  # Processing Code
      field iso004, id: 4, required: true  # Amount, Transaction
      field iso007, id: 7                  # Transmission Date & Time
      field iso011, id: 11                 # Systems Trace Audit Number
      field iso012, id: 12                 # Date/Time, Local Transaction
      field iso032, id: 32                 # Acquiring Institution ID Code
      field iso033, id: 33                 # Forwarding Institution ID Code
      field iso037, id: 37                 # Retrieval Reference Number
      field iso038, id: 38                 # Authorization ID Response
      field iso039, id: 39, required: true # Response Code
      field iso041, id: 41                 # Card Acceptor Terminal ID
      field iso049, id: 49                 # Currency Code, Transaction
      field iso090, id: 90, required: true # Original Data Elements
      field iso095, id: 95                 # Replacement Amounts
      field iso100, id: 100                # Receiving Institution ID Code
      field iso102, id: 102                # Account Identification 1
    end
  end
end
