module Buttons
  module ForImageMessage
    class ForImageToVideo < Buttons::Base
      def build
        [provide_prompt_row, *processor_rows]
      end

      private

      def provide_prompt_row
        [{
          text: I18n.t("telegram_webhooks.message.buttons.image_to_video.provide_prompt", locale:),
          callback_data: ButtonActions::PROVIDE_PROMPT
        }]
      end

      def processor_rows
        media_processors.map { |processor| [button_for(:generate_video, processor)] }
      end

      def media_processors
        COSTS[:generate_video].keys
      end
    end
  end
end
