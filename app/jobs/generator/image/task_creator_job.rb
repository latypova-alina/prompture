module Generator
  module Image
    class TaskCreatorJob < ::Clients::Generator::BaseApiRequest
      include Sidekiq::Job
      include Memery

      def perform(prompt, button_request, chat_id)
        @prompt = prompt
        @chat_id = chat_id
        @button_request = button_request

        raise ::Freepik::ResponseError unless response.success?
      rescue Freepik::ResponseError
        Generator::Image::ErrorNotifierJob.perform_async(chat_id)
      end

      private

      attr_reader :prompt, :chat_id, :button_request

      memoize def response
        connection.post { |req| req.body = final_payload.to_json }
      end

      def payload
        raise NotImplementedError
      end

      def final_payload
        payload.reverse_merge(webhook_url:, prompt:)
      end

      def webhook_url
        # TODO: send parent_class so it can be updated later
        "#{webhook_host}/freepik/webhook?token=#{token}&button_request=#{button_request}"
      end

      def webhook_host
        return ENV["GENERATOR_WEBHOOK_BASE_URL"] unless Rails.env.production?

        ENV["PRODUCTION_BASE_URL"]
      end

      def token
        ChatToken.encode(chat_id)
      end
    end
  end
end
