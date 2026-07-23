module Buttons
  module ForBloomy
    class GenerateComplexVideos < Buttons::Base
      PROCESSOR = "kling_3_standard_image_to_video".freeze

      def initialize(pairs_count:, **kwargs)
        super(**kwargs)
        @pairs_count = pairs_count
      end

      def build
        [[{
          text: I18n.t(
            "telegram_webhooks.message.buttons.generate_bloomy_complex_videos",
            count: total_cost,
            locale:
          ),
          callback_data: ButtonActions::GENERATE_BLOOMY_COMPLEX_VIDEOS
        }]]
      end

      private

      attr_reader :pairs_count

      def total_cost
        cost_for(:generate_video, PROCESSOR) * pairs_count
      end
    end
  end
end
