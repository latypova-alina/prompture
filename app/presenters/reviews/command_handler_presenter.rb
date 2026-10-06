module Reviews
  class CommandHandlerPresenter < ::BasePresenter
    include ::MessageInterface

    def initialize(locale:, reward:)
      super(locale:)
      @reward = reward
    end

    def formatted_text
      return I18n.t("telegram_webhooks.commands.review.ask", locale:) unless reward

      I18n.t("telegram_webhooks.commands.review.ask_with_reward", count: Reviews::Reward::CREDITS, locale:)
    end

    def inline_keyboard
      [[{ text: I18n.t("telegram_webhooks.commands.review.button", locale:), web_app: { url: mini_app_url } }]]
    end

    private

    attr_reader :reward

    def mini_app_url
      "#{PublicBaseUrl.resolve}#{Rails.application.routes.url_helpers.mini_app_review_path}"
    end
  end
end
