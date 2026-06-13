module CrystalIso8583
  module V1993
    class Msg1110 < TypedMessage
      mti "1110"

      field iso002, id: 2                   # PAN
      field iso003, id: 3, required: true   # Processing Code
      field iso004, id: 4, required: true   # Amount, Transaction
      field iso006, id: 6                   # Amount, Cardholder Billing
      field iso007, id: 7                   # Transmission Date & Time
      field iso011, id: 11                  # Systems Trace Audit Number
      field iso012, id: 12                  # Date/Time, Local Transaction
      field iso014, id: 14                  # Date, Expiration
      field iso032, id: 32                  # Acquiring Institution ID Code
      field iso033, id: 33                  # Forwarding Institution ID Code
      field iso037, id: 37                  # Retrieval Reference Number
      field iso038, id: 38                  # Authorization ID Response
      field iso039, id: 39, required: true  # Response Code
      field iso041, id: 41                  # Card Acceptor Terminal ID
      field iso044, id: 44                  # Additional Response Data
      field iso048, id: 48                  # Additional Data - Private
      field iso049, id: 49                  # Currency Code, Transaction
      field iso051, id: 51                  # Currency Code, Cardholder Billing
      field iso054, id: 54                  # Additional Amounts
      field iso055, id: 55                  # ICC Data
      field iso063, id: 63                  # Reserved Private
      field iso093, id: 93                  # Transaction Destination Institution ID Code
      field iso094, id: 94                  # Transaction Originator Institution ID Code
      field iso100, id: 100                 # Receiving Institution ID Code
      field iso102, id: 102                 # Account Identification 1
    end
  end
end
