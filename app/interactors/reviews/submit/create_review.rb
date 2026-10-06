module Reviews
  class Submit
    # Creates the review and, while the review bonus is on, grants the reward in the same DB
    # transaction - so there's never a review without its stones or stones without a review.
    class CreateReview
      include Interactor
      include Memery

      delegate :user, :locale, :normalized_answers, to: :context

      def call
        ActiveRecord::Base.transaction do
          context.review = create_review
          grant_reward if rewarded?
        end

        context.reward_credits = Reviews::Reward::CREDITS if rewarded?
      rescue ActiveRecord::RecordNotUnique
        # Two submits racing past EnsureNotReviewed - the unique index on user_id decides, and the
        # whole transaction (review + grant) rolls back.
        context.fail!(error: Reviews::AlreadyReviewedError)
      end

      private

      def create_review
        Review.create!(
          user:,
          rating: normalized_answers.fetch("rating"),
          answers: normalized_answers,
          survey_version: Reviews::Survey::CURRENT_VERSION,
          locale:
        )
      end

      def grant_reward
        Billing::CreditsGranter.call(user:, amount: Reviews::Reward::CREDITS, source: context.review)
      end

      memoize def rewarded?
        Reviews::Reward.enabled_for?(user)
      end
    end
  end
end
