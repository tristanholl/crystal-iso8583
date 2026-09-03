module CrystalISO8583
  module V1993
    class Msg1814 < TypedMessage
      mti "1814"

      field iso011, id: 11, required: true  # System Trace Audit Number (STAN) — = (mirrored, M)
      field iso012, id: 12, required: true  # Date and Time, Local Transaction — = (mirrored, M)
      field iso039, id: 39, required: true  # Action Code — M
      field iso053, id: 53                  # Security Related Control Information — C
      field iso093, id: 93, required: true  # Transaction Destination Institution Identification Code — = (mirrored, M)
      field iso094, id: 94, required: true  # Transaction Originator Identification Code — = (mirrored, M)
      field iso111, id: 111                 # Encryption Data — C
      field iso128, id: 128, required: true # Message Authentication Code (MAC) Field — M
    end
  end
end
