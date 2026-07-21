module MediaGenerator
  module UserMessage
    module ImageMessage
      module ForTwoFramesCommand
        class PromptMessagePresenter < ::BasePresenter
          include MessageInterface

          def formatted_text
            I18n.t("telegram_webhooks.message.image_message_reply", locale:)
          end

          def inline_keyboard
            Buttons::ForPromptMessage::ForFirstLastFrameToVideo.build(locale:)
          end
        end
      end
    end
  end
end
