module Buttons
  class ForSetLocale
    def self.build
      new.build
    end

    def build
      Rails.application.config.x.supported_locales.map do |locale|
        [
          {
            text: I18n.t("telegram_webhooks.message.buttons.set_locale.#{locale}"),
            callback_data: "set_locale:#{locale}"
          }
        ]
      end
    end
  end
end
