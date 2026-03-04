module Generator::Media::Video::NotifySuccess
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
        ::Telegram.bot.send_message(chat_id:, **reply_data)
      end
    end

    private

    attr_reader :reply_data, :request

    delegate :locale, :chat_id, to: :request
  end
end
