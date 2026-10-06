module StarsPayment
  # The "🛒 Open Store" inline button that opens the buy-stones Mini App - shared by /buy_stones and
  # the "not enough stones" error reply.
  module OpenStoreButton
    def self.call(locale:)
      {
        text: I18n.t("telegram_webhooks.commands.buy_stones.open_store_button", locale:),
        web_app: { url: "#{PublicBaseUrl.resolve}#{Rails.application.routes.url_helpers.mini_app_buy_stones_path}" }
      }
    end
  end
end
