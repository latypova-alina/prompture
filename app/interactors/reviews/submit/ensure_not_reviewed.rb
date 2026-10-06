module Reviews
  class Submit
    class EnsureNotReviewed
      include Interactor

      delegate :user, to: :context

      def call
        context.fail!(error: Reviews::AlreadyReviewedError) if Review.exists?(user:)
      end
    end
  end
end
