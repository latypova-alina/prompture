module Generator::Media::Image::NotifySuccess
  module ForBloomy
    class PresenterFactory
      def initialize(image_url:, request:, balance:)
        @image_url = image_url
        @request = request
        @balance = balance
      end

      def presenter
        MediaGenerator::ButtonRequestPresenters::ImageProcessedMessage::ForBloomy::ForShortComplexScript.new(
          message: image_url,
          locale:,
          balance:,
          processor_name: humanized_process_name,
          processor:
        )
      end

      private

      attr_reader :image_url, :request, :balance

      delegate :locale, :humanized_process_name, :processor, to: :request
    end
  end
end
