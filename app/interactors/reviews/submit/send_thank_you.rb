module Reviews
  class Submit
    class SendThankYou
      include Interactor
      include Memery

      delegate :user, :locale, :review, :reward_credits, to: :context
      delegate :chat_id, to: :user
      delegate :text, to: :presenter

      # The review is already saved, so a Telegram failure (bot blocked, rate limit, network) must not
      # turn the submit into an error - the user would retry and hit "already reviewed". Report it instead.
      def call
        Telegram.bot.send_message(chat_id:, text:)
      rescue Telegram::Bot::Error => e
        Sentry.capture_exception(e, extra: { review_id: review.id })
      end

      private

      memoize def presenter
        Reviews::ThankYouPresenter.new(locale:, reward_credits:, balance: current_balance)
      end

      # Read fresh after the grant - the cached user.balance may predate it (or not exist yet).
      def current_balance
        Balance.find_by!(user:).credits if reward_credits
      end
    end
  end
end
