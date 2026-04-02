module MediaGenerator
  module UserMessagePresenters
    class ImageMessagePresenter < ::BasePresenter
      include MessageInterface

      def formatted_text
        <<~HTML
          <a href="#{message}">#{I18n.t('telegram_webhooks.message.image_message_url', locale:)}</a>

          #{I18n.t('telegram_webhooks.message.image_message_reply', locale:)}
        HTML
      end

      def inline_keyboard
        Buttons::ForImageMessage::ForImageToVideo.build(locale:)
      end
    end
  end
end
