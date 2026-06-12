module ISO8583
  module V1987
    module Messages
      # ISO 8583:1987 Authorization Request — MTI 0100
      #
      # Core mandatory fields per the 1987 spec:
      #   DE 2  Primary Account Number (or DE 35 Track 2)
      #   DE 3  Processing Code
      #   DE 4  Amount, Transaction
      #   DE 7  Transmission Date and Time
      #   DE 11 System Trace Audit Number (STAN)
      #   DE 12 Time, Local Transaction
      #   DE 13 Date, Local Transaction
      #   DE 14 Date, Expiration
      #   DE 22 Point of Service Entry Mode
      #   DE 24 Network International Identifier
      #   DE 25 Point of Service Condition Code
      #   DE 41 Card Acceptor Terminal Identification
      #   DE 42 Card Acceptor Identification Code
      #   DE 49 Currency Code, Transaction
      class AuthRequest < V1987::Message
        MTI_VALUE = "0100"

        # Convenience constructor — builds a message from named field values.
        # All parameters are optional keyword arguments; only set fields appear in
        # the bitmap and binary output.
        def self.build(
          pan : String? = nil,
          processing_code : String? = nil,
          amount : String? = nil,
          transmission_datetime : String? = nil,
          stan : String? = nil,
          local_time : String? = nil,
          local_date : String? = nil,
          expiry : String? = nil,
          pos_entry_mode : String? = nil,
          nii : String? = nil,
          pos_condition_code : String? = nil,
          track2 : String? = nil,
          rrn : String? = nil,
          terminal_id : String? = nil,
          merchant_id : String? = nil,
          merchant_name : String? = nil,
          currency_code : String? = nil,
          pin_data : String? = nil,
          icc_data : String? = nil,
        ) : AuthRequest
          mti = Shared::MTI.from_string(MTI_VALUE)
          elements = {} of Int32 => Shared::DataElement
          msg = AuthRequest.new(mti, elements)
          {2 => pan, 3 => processing_code, 4 => amount,
           7 => transmission_datetime, 11 => stan,
           12 => local_time, 13 => local_date, 14 => expiry,
           22 => pos_entry_mode, 24 => nii, 25 => pos_condition_code,
           35 => track2, 37 => rrn, 41 => terminal_id,
           42 => merchant_id, 43 => merchant_name,
           49 => currency_code, 52 => pin_data, 55 => icc_data}.each do |num, val|
            val.try { |v| msg.set_field(num, v) }
          end
          msg
        end

        def pan : String?                  = field_value(2)
        def processing_code : String?      = field_value(3)
        def amount : String?               = field_value(4)
        def transmission_datetime : String? = field_value(7)
        def stan : String?                 = field_value(11)
        def local_time : String?           = field_value(12)
        def local_date : String?           = field_value(13)
        def expiry : String?               = field_value(14)
        def pos_entry_mode : String?       = field_value(22)
        def nii : String?                  = field_value(24)
        def pos_condition_code : String?   = field_value(25)
        def track2 : String?               = field_value(35)
        def rrn : String?                  = field_value(37)
        def terminal_id : String?          = field_value(41)
        def merchant_id : String?          = field_value(42)
        def merchant_name : String?        = field_value(43)
        def currency_code : String?        = field_value(49)
        def pin_data : String?             = field_value(52)
        def icc_data : String?             = field_value(55)
      end
    end
  end
end
