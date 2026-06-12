module Generator::Media::Merge::NotifySuccess
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

    delegate :locale, to: :request
    delegate :origin_telegram_message_id, to: :request

    def reply_data_with_reply_reference
      return reply_data unless origin_telegram_message_id.present?

      reply_data.merge(reply_to_message_id: origin_telegram_message_id)
    end
  end
end
