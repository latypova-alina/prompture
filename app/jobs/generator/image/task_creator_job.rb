module Generator
  module Image
    class TaskCreatorJob < ApplicationJob
      include ::Clients::Generator::BaseApiRequest
      include Memery
      include Generator::WithLocaleInterface

      def perform(prompt, chat_id, button_request, button_request_id)
        @prompt = prompt
        @button_request = button_request
        @chat_id = chat_id
        @button_request_id = button_request_id

        raise ::Freepik::ResponseError unless response.success?
      rescue Freepik::ResponseError
        Billing::Refunder.call(user:, amount: request.cost, source: request)
        Generator::Image::ErrorNotifierJob.perform_async(chat_id, locale)
      end

      private

      attr_reader :prompt, :chat_id, :button_request, :button_request_id

      delegate :webhook_url, to: :webhook_url_builder
      delegate :user, to: :request

      memoize def response
        connection.post { |req| req.body = final_payload.to_json }
      end

      def payload
        raise NotImplementedError
      end

      def final_payload
        payload.reverse_merge(webhook_url:, prompt:)
      end

      def request_class
        ButtonImageProcessingRequest
      end

      def webhook_url_builder
        Generator::WebhookUrlBuilder.new(button_request, button_request_id, chat_id)
      end
    end
  end
end
