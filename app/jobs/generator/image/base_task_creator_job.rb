module Generator
  module Image
    class BaseTaskCreatorJob < ::Generator::BaseApiRequestJob
      include Memery

      def perform(prompt, chat_id)
        @prompt = prompt
        @chat_id = chat_id

        raise ::Freepik::ResponseError unless response.success?
      rescue Freepik::ResponseError
        Generator::Image::ErrorNotifierJob.perform_async(chat_id)
      end

      private

      attr_reader :prompt, :chat_id

      memoize def response
        connection.post { |req| req.body = final_payload.to_json }
      end

      def final_payload
        payload.reverse_merge(webhook_url:, prompt:)
      end

      def payload
        raise NotImplementedError
      end

      def webhook_url
        "#{ENV['GENERATOR_WEBHOOK_BASE_URL']}/freepik/webhook?token=#{token}"
      end

      def token
        ChatToken.encode(chat_id)
      end
    end
  end
end
