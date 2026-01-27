module MessageHandler
  class NotifyUser
    include Interactor

    delegate :command_request, :chat_id, to: :context

    def call
      Telegram::SendMessageWithButtons.call(
        chat_id:,
        reply_data:,
        request: command_request
      )
    end

    private

    delegate :reply_data, to: :presenter

    def presenter
      CommandRequestPresenters::MessagePresenter.new(command_request)
    end
  end
end
