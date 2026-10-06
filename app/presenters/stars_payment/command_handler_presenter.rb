module StarsPayment
  class CommandHandlerPresenter < ::BasePresenter
    include ::MessageInterface

    def formatted_text
      I18n.t("telegram_webhooks.commands.buy_stones.ask", locale:)
    end

    def inline_keyboard
      [[StarsPayment::OpenStoreButton.call(locale:)]]
    end
  end
end
