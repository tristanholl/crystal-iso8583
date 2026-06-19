require "json"

module CrystalIso8583
  module Shared
    class Message
      getter mti : MTI
      getter bitmap : Bitmap
      getter fields : Hash(Int32, FieldValue)

      def initialize(@mti, @bitmap, @fields)
      end

      def to_json(dictionary : Hash(Int32, FieldDescriptor)? = nil) : String
        JSON.build do |json|
          json.object do
            json.field "mti", mti.to_s
            json.field "fields" do
              json.object do
                fields.each do |id, fv|
                  json.field id.to_s do
                    json.object do
                      json.field "label", dictionary.try { |d| d[id]?.try(&.label) }
                      json.field "value", fv.decoded
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
