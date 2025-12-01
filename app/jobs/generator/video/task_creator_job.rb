module Generator
  module Video
    class TaskCreatorJob < ::Clients::Generator::BaseApiRequest
      include Sidekiq::Job
      include Memery

      def perform(prompt, image_url, button_request, chat_id)
        @prompt = prompt
        @chat_id = chat_id
        @button_request = button_request
        @image_url = image_url

        raise ::Freepik::ResponseError unless response.success?
      rescue Freepik::ResponseError
        Generator::Video::ErrorNotifierJob.perform_async(chat_id)
      end

      private

      attr_reader :prompt, :chat_id, :button_request, :image_url

      memoize def response
        connection.post { |req| req.body = final_payload.to_json }
      end

      def payload
        raise NotImplementedError
      end

      def final_payload
        payload.reverse_merge(webhook_url:, prompt:, image: image_url)
      end

      def webhook_url
        "#{webhook_host}/freepik/webhook?token=#{token}&button_request=#{button_request}"
      end

      def webhook_host
        return ENV["GENERATOR_WEBHOOK_BASE_URL"] if Rails.env.development?

        ENV["PRODUCTION_BASE_URL"]
      end

      def token
        ChatToken.encode(chat_id)
      end
    end
  end
end
