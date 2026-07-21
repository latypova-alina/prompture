module MediaGenerator
  module UserMessage
    module ImageMessage
      module ForTwoFramesCommand
        class ReadyFramePresenter < ::BasePresenter
          include MessageInterface

          def formatted_text
            I18n.t("telegram_webhooks.message.first_last_frame_to_video_ready_reply", locale:)
          end

          def inline_keyboard
            Buttons::ForImageMessage::ForFirstLastFrameToVideo.build(locale:)
          end
        end
      end
    end
  end
end
