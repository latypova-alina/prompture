module Reviews
  class Submit
    class SendThankYou
      include Interactor

      delegate :user, :locale, to: :context
      delegate :chat_id, to: :user

      def call
        Telegram.bot.send_message(chat_id:, text: I18n.t("reviews.thank_you", locale:))
      end
    end
  end
end
