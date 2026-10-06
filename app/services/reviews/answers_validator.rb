module Reviews
  # Checks submitted answers against a survey version. The server is the authority: the mini app
  # mirrors these rules for UX only.
  class AnswersValidator
    include Memery

    VALIDATORS = {
      rating: AnswerValidators::Rating,
      text: AnswerValidators::Text,
      single_choice: AnswerValidators::Choice,
      multi_choice: AnswerValidators::Choice
    }.freeze

    def initialize(answers:, version: Survey::CURRENT_VERSION)
      @answers = answers.is_a?(Hash) ? answers.deep_stringify_keys : {}
      @version = version
    end

    def valid?
      errors.empty?
    end

    # { "question_id" => :error_key } for every invalid answer.
    memoize def errors
      validators.each_with_object({}) do |(question, validator), errors|
        next if skipped?(question)

        error = validator.error
        errors[question.id] = error if error
      end
    end

    # Normalized answers for known questions only, keyed by question id.
    def normalized_answers
      validators.each_with_object({}) do |(question, validator), normalized|
        normalized[question.id] = validator.value unless skipped?(question)
      end
    end

    private

    attr_reader :answers, :version

    memoize def validators
      Survey.questions(version).to_h do |question|
        [question, VALIDATORS.fetch(question.type).new(question:, answer: answers[question.id])]
      end
    end

    def skipped?(question)
      !question.required && answers[question.id].blank?
    end
  end
end
