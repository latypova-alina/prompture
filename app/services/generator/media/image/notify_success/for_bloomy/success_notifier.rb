module Generator::Media::Image::NotifySuccess
  module ForBloomy
    class SuccessNotifier < Generator::Media::Image::NotifySuccess::SuccessNotifier
      def call
        super

        enqueue_next_chained_scene
      end

      private

      def enqueue_next_chained_scene
        ScriptGenerator::ForBloomy::EnqueueNextChainedScene.call(
          image_url:,
          button_request: request
        )
      end
    end
  end
end
