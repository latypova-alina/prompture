module Generator
  class WebhookUrlBuilder
    def initialize(button_request, request_id, chat_id)
      @button_request = button_request
      @request_id = request_id
      @chat_id = chat_id
    end

    def webhook_url
      "#{webhook_host}/prompt_to_image_webhook?token=#{token}&button_request=#{button_request}&request_id=#{request_id}"
    end

    private

    attr_reader :button_request, :request_id, :chat_id

    def webhook_host
      return ENV["GENERATOR_WEBHOOK_BASE_URL"] unless Rails.env.production?

      ENV["PRODUCTION_BASE_URL"]
    end

    def token
      ChatToken.encode(chat_id)
    end
  end
end
