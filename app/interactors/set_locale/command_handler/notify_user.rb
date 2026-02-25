module SetLocale
  module CommandHandler
    class NotifyUser
      include Interactor
      include Memery

      delegate :locale, :chat_id, to: :context

      def call
        ::Telegram.bot.send_message(chat_id:, **reply_data)
      end

      private

      delegate :reply_data, to: :presenter

      memoize def presenter
        LocaleCommandHandlerPresenter.new(locale:)
      end
    end
  end
end
