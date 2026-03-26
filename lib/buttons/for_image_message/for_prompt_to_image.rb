module Buttons
  module ForImageMessage
    class ForPromptToImage
      def self.build(...)
        new(...).build
      end

      def initialize(locale: I18n.locale)
        @locale = locale
      end

      def build
        []
      end

      private

      attr_reader :locale
    end
  end
end
