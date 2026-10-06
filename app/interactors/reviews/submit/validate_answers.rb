module Reviews
  class Submit
    class ValidateAnswers
      include Interactor
      include Memery

      delegate :answers, to: :context
      delegate :errors, :normalized_answers, to: :validator

      def call
        context.fail!(error: Reviews::InvalidAnswersError, answer_errors: errors) unless validator.valid?

        context.normalized_answers = normalized_answers
      end

      private

      memoize def validator
        Reviews::AnswersValidator.new(answers:)
      end
    end
  end
end
