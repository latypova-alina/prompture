module Generator
  module Image
    class TaskCreatorJob < BaseNotifierJob
      include ::Clients::Generator::BaseApiRequest
      include Memery

      def perform(button_request_id)
        @button_request_id = button_request_id

        raise ::Freepik::ResponseError unless response.success?
      rescue Freepik::ResponseError
        Billing::Refunder.call(user:, amount: cost, source: request)
        Generator::Image::ErrorNotifierJob.perform_async(button_request_id)
      end

      private

      attr_reader :button_request_id

      delegate :parent_request, :user, :processor, :cost, to: :request
      delegate :webhook_url, to: :webhook_url_builder

      memoize def response
        connection.post { |req| req.body = final_payload.to_json }
      end

      def payload
        raise NotImplementedError
      end

      def final_payload
        payload.reverse_merge(webhook_url:, prompt:)
      end

      def prompt
        parent_request.parent_prompt
      end

      def webhook_url_builder
        Generator::WebhookUrlBuilder.new(processor:, button_request_id:)
      end
    end
  end
end
