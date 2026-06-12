module ISO8583
  module V1993
    module Messages
      # ISO 8583:1993 Authorization Advice Response — MTI 1130
      class AuthAdviceResponse < V1993::Message
        MTI_VALUE = "1130"

        def self.build(
          pan : String? = nil,
          processing_code : String? = nil,
          amount : String? = nil,
          transmission_datetime : String? = nil,
          stan : String? = nil,
          local_time : String? = nil,
          local_date : String? = nil,
          nii : String? = nil,
          rrn : String? = nil,
          auth_id_response : String? = nil,
          response_code : String? = nil,
          terminal_id : String? = nil,
        ) : AuthAdviceResponse
          mti = Shared::MTI.from_string(MTI_VALUE)
          elements = {} of Int32 => Shared::DataElement
          msg = AuthAdviceResponse.new(mti, elements)
          {2 => pan, 3 => processing_code, 4 => amount,
           7 => transmission_datetime, 11 => stan,
           12 => local_time, 13 => local_date, 24 => nii,
           37 => rrn, 38 => auth_id_response,
           39 => response_code, 41 => terminal_id}.each do |num, val|
            val.try { |v| msg.set_field(num, v) }
          end
          msg
        end

        def pan : String?                   = field_value(2)
        def processing_code : String?       = field_value(3)
        def amount : String?                = field_value(4)
        def transmission_datetime : String? = field_value(7)
        def stan : String?                  = field_value(11)
        def local_time : String?            = field_value(12)
        def local_date : String?            = field_value(13)
        def nii : String?                   = field_value(24)
        def rrn : String?                   = field_value(37)
        def auth_id_response : String?      = field_value(38)
        def response_code : String?         = field_value(39)
        def terminal_id : String?           = field_value(41)

        def accepted? : Bool
          response_code == "00"
        end
      end
    end
  end
end
