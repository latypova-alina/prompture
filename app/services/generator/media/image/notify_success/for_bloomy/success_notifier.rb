module Generator::Media::Image::NotifySuccess
  module ForBloomy
    class SuccessNotifier < Generator::Media::Image::NotifySuccess::SuccessNotifier
      def call
        super

        enqueue_next_chained_scene
        send_generate_videos_cta
      end

      private

      def presenter_factory
        PresenterFactory.new(image_url:, request:, balance: balance_credits)
      end

      def enqueue_next_chained_scene
        ScriptGenerator::ForBloomy::EnqueueNextChainedScene.call(
          image_url:,
          button_request: request
        )
      end

      def send_generate_videos_cta
        ScriptGenerator::ForBloomy::GenerateVideosCta::Generator.call(button_request: request)
      end
    end
  end
end
