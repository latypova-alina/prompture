module MediaGenerator
  module UserMessage
    module ImageMessage
      module ForTwoFramesCommand
        class StartFramePresenter < ::BasePresenter
          include MessageInterface

          def formatted_text
            I18n.t("telegram_webhooks.message.first_last_frame_to_video_start_image_reply", locale:)
          end

          def inline_keyboard
            []
          end
        end
      end
    end
  end
end
