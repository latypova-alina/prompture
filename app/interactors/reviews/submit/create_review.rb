module Reviews
  class Submit
    class CreateReview
      include Interactor

      delegate :user, :locale, :normalized_answers, to: :context

      def call
        context.review = Review.create!(
          user:,
          rating: normalized_answers.fetch("rating"),
          answers: normalized_answers,
          survey_version: Reviews::Survey::CURRENT_VERSION,
          locale:
        )
      rescue ActiveRecord::RecordNotUnique
        # Two submits racing past EnsureNotReviewed - the unique index on user_id decides.
        context.fail!(error: Reviews::AlreadyReviewedError)
      end
    end
  end
end
