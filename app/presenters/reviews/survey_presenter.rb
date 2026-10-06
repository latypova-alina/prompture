module Reviews
  # The survey as JSON for the mini app, localized: question labels/options plus the UI strings the
  # page needs (it can't localize itself - the plain GET doesn't know who the user is).
  class SurveyPresenter
    UI_KEYS = %i[title intro submit sending success other_placeholder text_placeholder].freeze
    ERROR_KEYS = %i[required too_short too_long invalid_option other_too_short generic already_reviewed].freeze

    def initialize(locale:, version: Survey::CURRENT_VERSION)
      @locale = locale
      @version = version
    end

    def as_json(*)
      {
        version:,
        ui: UI_KEYS.index_with { |key| t("reviews.mini_app.#{key}") },
        errors: ERROR_KEYS.index_with { |key| t("reviews.mini_app.errors.#{key}", count: min_length, max:) },
        max_length: max,
        questions: Survey.questions(version).map { |question| question_json(question) }
      }
    end

    private

    attr_reader :locale, :version

    def question_json(question)
      {
        id: question.id,
        type: question.type,
        required: question.required,
        min_length: question.min_length,
        title: t("#{scope}.questions.#{question.id}.title"),
        options: Array(question.options).map { |option| option_json(question, option) },
        other: question.other ? { label: t("reviews.mini_app.other_label"), min_length: question.min_length } : nil
      }
    end

    def option_json(question, option)
      { id: option, label: t("#{scope}.questions.#{question.id}.options.#{option}") }
    end

    def scope
      Survey.i18n_scope(version)
    end

    def min_length
      Survey::V1::MIN_TEXT_LENGTH
    end

    def max
      AnswerValidators::Base::MAX_TEXT_LENGTH
    end

    def t(key, **)
      I18n.t(key, locale:, **)
    end
  end
end
