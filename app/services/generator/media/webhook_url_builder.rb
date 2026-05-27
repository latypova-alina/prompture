module Generator
  module Media
    class WebhookUrlBuilder
      PROCESSOR_WEBHOOK_PATHS = {
        "flux_image" => "/api/fal/webhook"
      }.freeze

      def initialize(processor:, button_request_id:)
        @processor = processor
        @button_request_id = button_request_id
      end

      def webhook_url
        "#{webhook_host}#{webhook_path}?request_id_token=#{request_id_token}&processor=#{processor}"
      end

      private

      attr_reader :processor, :button_request_id

      def webhook_host
        return ENV["GENERATOR_WEBHOOK_BASE_URL"] unless Rails.env.production?

        ENV["PRODUCTION_BASE_URL"]
      end

      def request_id_token
        RequestIdToken.encode(button_request_id)
      end

      def webhook_path
        PROCESSOR_WEBHOOK_PATHS.fetch(processor, "/freepik_webhook")
      end
    end
  end
end
