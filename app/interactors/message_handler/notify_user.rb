module MessageHandler
  class NotifyUser
    include interactor

    delegate :parent_request, :chat_id, to: :context

    def call
      Telegram.bot.send_message(
        chat_id:,
        **MessagePresenter.new(parent_request).reply_data
      )
    end
  end
end
