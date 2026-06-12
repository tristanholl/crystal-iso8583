module ISO8583
  module V1987
    module Messages
      # ISO 8583:1987 Authorization Response — MTI 0110
      #
      # Core fields echoed from the request plus the issuer's decision:
      #   DE 2  Primary Account Number (echoed)
      #   DE 3  Processing Code (echoed)
      #   DE 4  Amount, Transaction (echoed)
      #   DE 7  Transmission Date and Time (echoed)
      #   DE 11 STAN (echoed)
      #   DE 12 Time, Local Transaction
      #   DE 13 Date, Local Transaction
      #   DE 24 NII (echoed)
      #   DE 37 Retrieval Reference Number (echoed)
      #   DE 38 Authorization Identification Response (present on approval)
      #   DE 39 Response Code
      #   DE 41 Terminal ID (echoed)
      class AuthResponse < V1987::Message
        MTI_VALUE = "0110"

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
          merchant_id : String? = nil,
          icc_data : String? = nil,
        ) : AuthResponse
          mti = Shared::MTI.from_string(MTI_VALUE)
          elements = {} of Int32 => Shared::DataElement
          msg = AuthResponse.new(mti, elements)
          {2 => pan, 3 => processing_code, 4 => amount,
           7 => transmission_datetime, 11 => stan,
           12 => local_time, 13 => local_date, 24 => nii,
           37 => rrn, 38 => auth_id_response, 39 => response_code,
           41 => terminal_id, 42 => merchant_id, 55 => icc_data}.each do |num, val|
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
        def merchant_id : String?           = field_value(42)
        def icc_data : String?              = field_value(55)

        def approved? : Bool
          response_code == "00"
        end
      end
    end
  end
end
