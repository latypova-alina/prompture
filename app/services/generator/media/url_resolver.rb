module Generator
  module Media
    class UrlResolver
      def initialize(fal_request_id:, processor:)
        @fal_request_id = fal_request_id
        @processor = processor
      end

      def status_url
        "#{base_url}/requests/#{fal_request_id}/status"
      end

      def cancel_url
        "#{base_url}/requests/#{fal_request_id}/cancel"
      end

      def base_url
        strategy_class.const_get(:API_URL)
      end

      private

      attr_reader :fal_request_id, :processor

      def strategy_class
        Generator::Media::Video::CreateTask::StrategySelector::STRATEGIES[processor] ||
          Generator::Media::Image::CreateTask::StrategySelector::STRATEGIES[processor]
      end
    end
  end
end
