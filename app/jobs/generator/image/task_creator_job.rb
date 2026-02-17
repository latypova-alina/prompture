module Generator
  module Image
    class TaskCreatorJob < ::Clients::Generator::BaseApiRequest
      include Sidekiq::Job
      include Memery

      def perform(prompt, chat_id, button_request, request_id)
        @prompt = prompt
        @button_request = button_request
        @chat_id = chat_id
        @request_id = request_id

        raise ::Freepik::ResponseError unless response.success?
      rescue Freepik::ResponseError
        Billing::Refunder.call(user:, amount: request.cost, source: request)
        Generator::Image::ErrorNotifierJob.perform_async(chat_id)
      end

      private

      attr_reader :prompt, :chat_id, :button_request, :request_id

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

      memoize def request
        ButtonImageProcessingRequest.find(request_id)
      end

      memoize def user
        User.find_by!(chat_id:)
      end

      def webhook_url_builder
        Generator::WebhookUrlBuilder.new(button_request, request_id, chat_id)
      end
    end
  end
end
