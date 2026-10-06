module Reviews
  class Submit
    class NotifyAdmin
      include Interactor

      delegate :review, to: :context

      def call
        AdminNewReviewNotifierJob.perform_async(review.id)
      end
    end
  end
end
