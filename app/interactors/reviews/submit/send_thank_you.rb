module Reviews
  class Submit
    class SendThankYou
      include Interactor

      delegate :user, :locale, :review, to: :context
      delegate :chat_id, to: :user

      # The review is already saved, so a Telegram failure (bot blocked, rate limit, network) must not
      # turn the submit into an error - the user would retry and hit "already reviewed". Report it instead.
      def call
        Telegram.bot.send_message(chat_id:, text: I18n.t("reviews.thank_you", locale:))
      rescue Telegram::Bot::Error => e
        Sentry.capture_exception(e, extra: { review_id: review.id })
      end
    end
  end
end
