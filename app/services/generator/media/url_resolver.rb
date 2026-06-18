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

      def base_url
        strategy_api_url.sub(%r{/edit\z}, "")
      end

      private

      attr_reader :fal_request_id, :processor

      def strategy_api_url
        strategy_class.const_get(:API_URL)
      end

      def strategy_class
        Generator::Media::Video::CreateTask::StrategySelector::STRATEGIES[processor] ||
          Generator::Media::Image::CreateTask::StrategySelector::STRATEGIES[processor]
      end
    end
  end
end
