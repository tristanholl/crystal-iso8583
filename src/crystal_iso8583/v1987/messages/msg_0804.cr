module CrystalISO8583
  module V1987
    # Network Management Request — "other" origin (digit 4 = 4).
    class Msg0804 < TypedMessage
      mti "0804"

      field iso007, id: 7, required: true  # Date and Time, Transmission — M
      field iso011, id: 11, required: true # Systems Trace Audit Number — M
      field iso053, id: 53                 # Security Related Control Information — C
      field iso064, id: 64                 # Message Authentication Code Field — C
      field iso070, id: 70, required: true # Network Management Information Code — M
    end
  end
end
