module MessageHandler
  class NotifyUser
    include Interactor

    delegate :command_request, :chat_id, to: :context

    def call
      Telegram::SendMessageWithButtons.call(
        chat_id:,
        presenter:,
        request: command_request
      )
    end

    private

    def presenter
      CommandRequestPresenters::MessagePresenter.new(command_request)
    end
  end
end
