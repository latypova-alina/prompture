module Generator
  module Image
    class TaskCreator
      include Clients::Generator::BaseApiRequest

      def self.call(...)
        new(...).call
      end

      def initialize(request, strategy)
        @request = request
        @strategy = strategy
      end

      def call
        raise Freepik::ResponseError unless response.success?
      end

      private

      attr_reader :request, :strategy

      delegate :processor, to: :request
      delegate :api_url, :payload, to: :strategy

      def response
        connection.post(api_url) do |req|
          req.body = final_payload.to_json
        end
      end

      def final_payload
        payload.reverse_merge(webhook_url:)
      end

      def webhook_url
        Generator::WebhookUrlBuilder.new(processor:, button_request_id: request.id).webhook_url
      end
    end
  end
end
