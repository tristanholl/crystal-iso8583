module ISO8583
  module V1987
    class Message < Shared::Message
      def dictionary : Hash(Int32, Shared::FieldDefinition)
        Dictionary::FIELDS
      end
    end
  end
end
