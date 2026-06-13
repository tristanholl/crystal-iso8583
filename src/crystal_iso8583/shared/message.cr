require "json"

module CrystalIso8583
  module Shared
    class Message
      getter mti : MTI
      getter bitmap : Bitmap
      getter fields : Hash(Int32, FieldValue)

      def initialize(@mti, @bitmap, @fields)
      end

      def to_json : String
        JSON.build do |json|
          json.object do
            json.field "mti", mti.to_s
            json.field "fields" do
              json.object do
                fields.each do |id, fv|
                  json.field id.to_s do
                    case decoded = fv.decoded
                    when String then json.string(decoded)
                    when Int64  then json.number(decoded)
                    when Bytes  then json.string(decoded.hexstring)
                    end
                  end
                end
              end
            end
          end
        end
      end
    end
  end
end
