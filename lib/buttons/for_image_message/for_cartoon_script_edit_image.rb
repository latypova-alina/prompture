module Buttons
  module ForImageMessage
    class ForCartoonScriptEditImage < ForEditImage
      def build
        [[regenerate_button], [regenerate_script_image_button], [generate_video_button]]
      end

      private

      def regenerate_script_image_button
        {
          text: I18n.t(
            "telegram_webhooks.message.buttons.regenerate_cartoon_script_image",
            count: image_cost,
            locale:
          ),
          callback_data: ButtonActions::REGENERATE_SINGLE_CARTOON_SCRIPT_IMAGE
        }
      end

      def image_cost
        COSTS[:edit_image][:nano_banana_edit_image]
      end

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
