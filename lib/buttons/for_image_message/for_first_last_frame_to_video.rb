module Buttons
  module ForImageMessage
    class ForFirstLastFrameToVideo < Buttons::Base
      PROCESSOR = "kling_3_standard_image_to_video".freeze

      def build
        [provide_prompt_row, [generate_video_button]]
      end

      private

      def provide_prompt_row
        [{
          text: I18n.t("telegram_webhooks.message.buttons.image_to_video.provide_prompt", locale:),
          callback_data: ButtonActions::PROVIDE_PROMPT
        }]
      end

      def generate_video_button
        button_for(:generate_video, PROCESSOR)
      end
    end
  end
end
