module Reviews
  class CommandHandlerPresenter < ::BasePresenter
    include ::MessageInterface

    def formatted_text
      I18n.t("telegram_webhooks.commands.review.ask", locale:)
    end

    def inline_keyboard
      [[{ text: I18n.t("telegram_webhooks.commands.review.button", locale:), web_app: { url: mini_app_url } }]]
    end

    private

    def mini_app_url
      "#{PublicBaseUrl.resolve}#{Rails.application.routes.url_helpers.mini_app_review_path}"
    end
  end
end
