module Buttons
  module ForImageMessage
    class ForCartoonScriptEditImage < ForEditImage
      def build
        [[regenerate_button], [generate_video_button]]
      end

      private

      def generate_video_button
        {
          text: I18n.t(
            "telegram_webhooks.message.buttons.generate_cartoon_video",
            count: veo_cost,
            locale:
          ),
          callback_data: ButtonActions::GENERATE_CARTOON_VIDEO
        }
      end

      def veo_cost
        COSTS[:generate_video][:veo3_1_lite_image_to_video]
      end
    end
  end
end
