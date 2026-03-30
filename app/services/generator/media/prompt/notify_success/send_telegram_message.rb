module Generator::Media::Prompt::NotifySuccess
  class SendTelegramMessage
    include LocaleSupport

    def self.call(...)
      new(...).call
    end

    def initialize(reply_data:, request:)
      @reply_data = reply_data
      @request = request
    end

    def call
      with_locale(locale) do
        ::TelegramIntegration::SendMessageWithButtons.call(
          reply_data: reply_data_with_reply_reference,
          request:
        )
      end
    end

    private

    attr_reader :reply_data, :request

    delegate :locale, :telegram_message, :parent_request, to: :request
    delegate :telegram_message, to: :parent_request, prefix: true, allow_nil: true
    delegate :tg_message_id, to: :telegram_message, prefix: true, allow_nil: true
    delegate :tg_message_id, to: :parent_request_telegram_message, prefix: true, allow_nil: true

    def reply_data_with_reply_reference
      reply_data.merge(reply_to_message_id: original_prompt_message_id).compact
    end

    def original_prompt_message_id
      telegram_message_tg_message_id || parent_request_telegram_message_tg_message_id
    end
  end
end
