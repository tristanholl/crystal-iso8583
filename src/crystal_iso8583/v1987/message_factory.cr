module CrystalIso8583
  module V1987
    module MessageFactory
      def self.build_0100 : Shared::Message
        Msg0100.new
      end

      def self.build_0110 : Shared::Message
        Msg0110.new
      end

      def self.build_0120 : Shared::Message
        Msg0120.new
      end

      def self.build_0121 : Shared::Message
        Msg0121.new
      end

      def self.build_0130 : Shared::Message
        Msg0130.new
      end

      def self.build_0420 : Shared::Message
        Msg0420.new
      end

      def self.build_0421 : Shared::Message
        Msg0421.new
      end

      def self.build_0430 : Shared::Message
        Msg0430.new
      end

      def self.build_0804 : Shared::Message
        Msg0804.new
      end

      def self.build_0814 : Shared::Message
        Msg0814.new
      end
    end
  end
end
