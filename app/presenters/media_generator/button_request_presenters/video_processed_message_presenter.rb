module MediaGenerator
  module ButtonRequestPresenters
    class VideoProcessedMessagePresenter < BasePresenter
      include MessageInterface

      def formatted_text
        "<a href=\"#{message}\">#{I18n.t('telegram_webhooks.message.video_processed', locale:)}</a>"
      end

      def inline_keyboard
        Buttons::ForVideoMessage.build
      end
    end
  end
end
