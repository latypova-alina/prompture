module StarsPayment
  class CommandHandlerPresenter < ::BasePresenter
    include ::MessageInterface

    def formatted_text
      I18n.t("telegram_webhooks.commands.buy_inks.ask", locale:)
    end

    def inline_keyboard
      button_text = I18n.t("telegram_webhooks.commands.buy_inks.open_store_button", locale:)

      [[{ text: button_text, web_app: { url: mini_app_url } }]]
    end

    private

    def mini_app_url
      "#{PublicBaseUrl.resolve}#{Rails.application.routes.url_helpers.mini_app_buy_inks_path}"
    end
  end
end
