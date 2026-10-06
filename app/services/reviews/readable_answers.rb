module Reviews
  # A stored review's answers as [question title, answer text] pairs, with labels resolved from
  # the survey version the review was answered with. Used by the admin page and admin notification.
  class ReadableAnswers
    STAR = "⭐".freeze

    def self.call(...)
      new(...).call
    end

    def initialize(review, locale: :en)
      @review = review
      @locale = locale
    end

    def call
      Survey.questions(survey_version).map do |question|
        [t("#{scope}.questions.#{question.id}.title"), answer_text(question, answers[question.id])]
      end
    end

    private

    attr_reader :review, :locale

    delegate :answers, :survey_version, to: :review

    def answer_text(question, answer)
      case question.type
      when :rating then "#{STAR * answer.to_i} #{answer}/5"
      when :single_choice, :multi_choice then choice_text(question, answer || {})
      else answer.to_s
      end
    end

    def choice_text(question, answer)
      labels = Array(answer["selected"]).map { |option| option_label(question, option, answer["other"]) }
      labels.join(", ")
    end

    def option_label(question, option, other_text)
      return "#{t('reviews.mini_app.other_label')}: #{other_text}" if option == AnswerValidators::Choice::OTHER

      t("#{scope}.questions.#{question.id}.options.#{option}")
    end

    def scope
      Survey.i18n_scope(survey_version)
    end

    def t(key)
      I18n.t(key, locale:)
    end
  end
end
