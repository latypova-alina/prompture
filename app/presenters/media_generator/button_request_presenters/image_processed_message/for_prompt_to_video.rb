module MediaGenerator
  module ButtonRequestPresenters
    module ImageProcessedMessage
      class ForPromptToVideo < BasePresenter
        include MessageInterface

        def formatted_text
          "<a href=\"#{message}\">#{I18n.t('telegram_webhooks.message.image_processed', locale:)}</a>"
        end

        def inline_keyboard
          Buttons::ForImageMessage::ForPromptToVideo.build
        end
      end
    end
  end
end
