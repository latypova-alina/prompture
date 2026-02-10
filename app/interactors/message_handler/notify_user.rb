module MessageHandler
  class NotifyUser
    include Interactor

    delegate :prompt_message, :chat_id, to: :context

    def call
      Telegram::SendMessageWithButtons.call(
        chat_id:,
        reply_data:,
        request: prompt_message
      )
    end

    private

    delegate :reply_data, to: :presenter

    def presenter
      UserMessagePresenters::MessagePresenter.new(user_message: prompt_message)
    end
  end
end
