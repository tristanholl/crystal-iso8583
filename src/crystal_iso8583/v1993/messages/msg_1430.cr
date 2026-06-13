module CrystalIso8583
  module V1993
    class Msg1430 < TypedMessage
      mti "1430"

      field iso002, id: 2
      field iso003, id: 3, required: true
      field iso004, id: 4, required: true
      field iso007, id: 7
      field iso011, id: 11
      field iso012, id: 12
      field iso032, id: 32
      field iso033, id: 33
      field iso037, id: 37
      field iso038, id: 38
      field iso039, id: 39, required: true
      field iso041, id: 41
      field iso049, id: 49
      field iso090, id: 90, required: true
      field iso095, id: 95
      field iso100, id: 100
      field iso102, id: 102
    end
  end
end
