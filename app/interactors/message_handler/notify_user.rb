module MessageHandler
  class NotifyUser
    include Interactor

    delegate :command_request, :chat_id, to: :context

    def call
      Telegram.bot.send_message(
        chat_id:,
        **CommandRequestPresenters::MessagePresenter.new(command_request).reply_data
      )
    end
  end
end
