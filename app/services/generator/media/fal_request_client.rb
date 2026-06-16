module Generator
  module Media
    class FalRequestClient
      def initialize(request)
        @request = request
      end

      def status
        response = connection.get(status_url)
        JSON.parse(response.body)["status"]
      end

      def cancel
        connection.put(cancel_url)
      end

      private

      attr_reader :request

      delegate :fal_request_id, :processor, to: :request

      def status_url
        "#{base_url}/requests/#{fal_request_id}/status"
      end

      def cancel_url
        "#{base_url}/requests/#{fal_request_id}/cancel"
      end

      def base_url
        strategy_class = Generator::Media::Video::CreateTask::StrategySelector::STRATEGIES[processor] ||
                         Generator::Media::Image::CreateTask::StrategySelector::STRATEGIES[processor]
        strategy_class.const_get(:API_URL)
      end

      def connection
        Clients::Generator::Connection::Fal.new(base_url).connection
      end
    end
  end
end
