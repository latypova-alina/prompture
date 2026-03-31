module Generator::Media::Prompt::NotifySuccess
  class SuccessNotifier
    include Memery

    def self.call(...)
      new(...).call
    end

    def initialize(extended_prompt:, button_request_id:)
      @extended_prompt = extended_prompt
      @button_request_id = button_request_id
    end

    def call
      send_telegram_message

      update_request_status
    end

    private

    delegate :reply_data, to: :presenter
    delegate :user, to: :request
    delegate :balance, to: :user
    delegate :credits, to: :balance, prefix: true
    attr_reader :extended_prompt, :button_request_id

    def send_telegram_message
      SendTelegramMessage.call(reply_data:, request:)
    end

    def update_request_status
      request.update!(status: "COMPLETED", prompt: extended_prompt)
    end

    memoize def presenter
      MediaGenerator::ButtonRequestPresenters::ExtendedPromptMessagePresenter.new(
        message: extended_prompt,
        balance: balance_credits,
        locale: request.locale
      )
    end

    memoize def request
      ButtonExtendPromptRequest.includes(
        { parent_request: :telegram_message },
        { command_request: { user: :balance } }
      ).find(button_request_id)
    end
  end
end
