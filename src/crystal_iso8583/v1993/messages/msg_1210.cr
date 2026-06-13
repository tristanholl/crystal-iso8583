module CrystalIso8583
  module V1993
    class Msg1210 < TypedMessage
      mti "1210"

      field iso002, id:   2, label: "PAN"
      field iso003, id:   3, label: "Processing Code",       required: true
      field iso004, id:   4, label: "Amount, Transaction",   required: true
      field iso006, id:   6, label: "Amount, Cardholder Billing"
      field iso007, id:   7, label: "Transmission Date & Time"
      field iso011, id:  11, label: "Systems Trace Audit Number"
      field iso012, id:  12, label: "Date/Time, Local Transaction"
      field iso014, id:  14, label: "Date, Expiration"
      field iso032, id:  32, label: "Acquiring Institution ID Code"
      field iso033, id:  33, label: "Forwarding Institution ID Code"
      field iso037, id:  37, label: "Retrieval Reference Number"
      field iso038, id:  38, label: "Authorization ID Response"
      field iso039, id:  39, label: "Response Code",         required: true
      field iso041, id:  41, label: "Card Acceptor Terminal ID"
      field iso044, id:  44, label: "Additional Response Data"
      field iso048, id:  48, label: "Additional Data - Private"
      field iso049, id:  49, label: "Currency Code, Transaction"
      field iso054, id:  54, label: "Additional Amounts"
      field iso055, id:  55, label: "ICC Data"
      field iso063, id:  63, label: "Reserved Private"
      field iso100, id: 100, label: "Receiving Institution ID Code"
      field iso102, id: 102, label: "Account Identification 1"
    end
  end
end
