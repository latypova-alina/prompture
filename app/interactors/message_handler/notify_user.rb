module MessageHandler
  class NotifyUser
    include interactor

    delegate :command_request, :chat_id, to: :context

    def call
      Telegram.bot.send_message(
        chat_id:,
        **MessagePresenter.new(command_request).reply_data
      )
    end
  end
end
