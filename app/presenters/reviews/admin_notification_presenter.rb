module Reviews
  # Admin chat message for a new review: who, the rating, short answers, and a link to the user
  # in the admin.
  class AdminNotificationPresenter
    MAX_ANSWER_LENGTH = 200

    def initialize(review)
      @review = review
    end

    def text
      [header, *answer_lines, admin_link].join("\n\n")
    end

    private

    attr_reader :review

    delegate :user, :rating, to: :review

    def header
      I18n.t("admin_notifications.new_review", name: user.name, user_id: user.id,
                                               stars: ReadableAnswers::STAR * rating, rating:, locale: :en)
    end

    # The rating is already in the header.
    def answer_lines
      ReadableAnswers.call(review).drop(1).map do |title, answer|
        "#{title}\n#{answer.truncate(MAX_ANSWER_LENGTH)}"
      end
    end

    def admin_link
      "https://#{AdminSubdomainAuth::ADMIN_HOST}/users/#{user.id}"
    end
  end
end
