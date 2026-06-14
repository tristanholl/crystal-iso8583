module CrystalIso8583
  module V1993
    # ISO 8583 v1993 message generator pre-wired with the V1993 data dictionary.
    # Use this instead of Shared::Generator when working with v1993 messages.
    class Generator < Shared::Generator
      def initialize(codec : Shared::Codec)
        super(DataDictionary.fields, codec)
      end
    end
  end
end
