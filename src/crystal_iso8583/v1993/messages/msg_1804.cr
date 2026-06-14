module CrystalIso8583
  module V1993
    class Msg1804 < TypedMessage
      mti "1804"

      field iso011, id: 11, required: true  # System Trace Audit Number (STAN) — M
      field iso012, id: 12, required: true  # Date and Time, Local Transaction — M
      field iso024, id: 24, required: true  # Function Code — M
      field iso025, id: 25, required: true  # Message Reason Code — M
      field iso053, id: 53                  # Security Related Control Information — C
      field iso093, id: 93, required: true  # Transaction Destination Institution Identification Code — M
      field iso094, id: 94, required: true  # Transaction Originator Identification Code — M
      field iso111, id: 111                 # Encryption Data — C
      field iso128, id: 128, required: true # Message Authentication Code (MAC) Field — M
    end
  end
end
