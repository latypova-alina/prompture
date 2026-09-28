module TermsGate
  class Check
    def self.call(...)
      new(...).call
    end

    def initialize(user:, chat_id:, locale:)
      @user = user
      @chat_id = chat_id
      @locale = locale
    end

    def call
      return true if accepted?

      send_gate_message
      false
    end

    private

    attr_reader :user, :chat_id, :locale

    def accepted?
      MiniApp::CurrentPolicyAcceptance.new(user:).present?
    end

    def send_gate_message
      Telegram.bot.send_message(chat_id:, **presenter.reply_data)
    end

    def presenter
      TermsGate::Presenter.new(locale:)
    end
  end
end
