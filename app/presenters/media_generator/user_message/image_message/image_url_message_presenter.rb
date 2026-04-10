module MediaGenerator
  module UserMessage
    module ImageMessage
      class ImageUrlMessagePresenter < ::BasePresenter
        include MessageInterface

        def formatted_text
          <<~HTML
            #{I18n.t('telegram_webhooks.message.image_message_reply', locale:)}
          HTML
        end

        def inline_keyboard
          Buttons::ForImageMessage::ForImageToVideo.build(locale:)
        end
      end
    end
  end
end
