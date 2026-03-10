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
        ::TelegramIntegration::SendMessageWithButtons.call(reply_data:, request:)
      end
    end

    private

    attr_reader :reply_data, :request

    delegate :locale, to: :request
  end
end
