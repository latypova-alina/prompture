module Reviews
  # Turns a failed review interactor result into the mini app's HTTP status + JSON body.
  class ErrorResponse
    include Memery

    STATUSES = {
      MiniApp::InvalidInitDataError => :unauthorized,
      Reviews::AlreadyReviewedError => :conflict,
      Reviews::InvalidAnswersError => :unprocessable_content
    }.freeze

    MESSAGE_KEYS = {
      MiniApp::InvalidInitDataError => "reviews.mini_app.errors.generic",
      Reviews::AlreadyReviewedError => "reviews.mini_app.errors.already_reviewed",
      Reviews::InvalidAnswersError => "reviews.mini_app.errors.fix_answers"
    }.freeze

    def initialize(result)
      @result = result
    end

    def status
      STATUSES.fetch(error)
    end

    def body
      { error: I18n.t(MESSAGE_KEYS.fetch(error), locale:), errors: answer_errors }.compact
    end

    private

    attr_reader :result

    memoize def error
      result.error
    end

    # Unauthenticated requests have no user, hence no locale yet.
    memoize def locale
      result.locale || I18n.default_locale
    end

    def answer_errors
      result.answer_errors&.transform_values do |key|
        I18n.t("reviews.mini_app.errors.#{key}", locale:, count: min_length, max: max_length)
      end
    end

    def min_length
      Reviews::Survey::V1::MIN_TEXT_LENGTH
    end

    def max_length
      Reviews::AnswerValidators::Base::MAX_TEXT_LENGTH
    end
  end
end
