module TermsGate
  class Presenter
    PRIVACY_POLICY_URL = "https://caivemanator.com/privacy_policy".freeze
    TERMS_OF_USE_URL = "https://www.caivemanator.com/terms_of_use".freeze

    def initialize(locale:)
      @locale = locale
    end

    def reply_data
      {
        parse_mode: "HTML",
        text: formatted_text,
        reply_markup: { inline_keyboard: [[agree_button]] }
      }
    end

    private

    attr_reader :locale

    def formatted_text
      I18n.t(
        "telegram_webhooks.message.terms_gate.prompt",
        privacy_link:,
        terms_link:,
        locale:
      )
    end

    def privacy_link
      html_link(PRIVACY_POLICY_URL, I18n.t("telegram_webhooks.message.terms_gate.privacy_link_text", locale:))
    end

    def terms_link
      html_link(TERMS_OF_USE_URL, I18n.t("telegram_webhooks.message.terms_gate.terms_link_text", locale:))
    end

    def html_link(url, text)
      %(<a href="#{url}">#{text}</a>)
    end

    def agree_button
      {
        text: I18n.t("telegram_webhooks.message.terms_gate.agree_button", locale:),
        callback_data: ButtonActions::ACCEPT_TERMS
      }
    end
  end
end
