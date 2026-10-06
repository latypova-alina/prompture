module Reviews
  module CommandHandler
    class HandleCommand
      include Interactor
      include Memery

      delegate :chat_id, :user, :locale, to: :context

      def call
        Telegram.bot.send_message(chat_id:, **reply_data)
      end

      private

      def reply_data
        return { text: I18n.t("telegram_webhooks.commands.review.already_reviewed", locale:) } if reviewed?

        presenter.reply_data
      end

      memoize def reviewed?
        Review.exists?(user:)
      end

      memoize def presenter
        Reviews::CommandHandlerPresenter.new(locale:)
      end
    end
  end
end
