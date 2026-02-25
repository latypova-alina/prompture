module SetLocale
  class CommandHandlerPresenter < ::BasePresenter
    include ::MessageInterface

    def formatted_text
      I18n.t("telegram_webhooks.commands.set_locale.ask", locale:)
    end

    def inline_keyboard
      Buttons::ForSetLocale.build
    end
  end
end
