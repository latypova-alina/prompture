module StarsPayment
  class InvoiceBuilder
    def initialize(pack_key:, pack:)
      @pack_key = pack_key
      @pack = pack
    end

    def invoice_url
      response["result"]
    end

    private

    attr_reader :pack_key, :pack

    def response
      ::Telegram.bot.create_invoice_link(
        title:,
        description:,
        payload: pack_key.to_s,
        provider_token: "",
        currency: "XTR",
        prices: [{ label: title, amount: pack[:stars] }]
      )
    end

    def title
      I18n.t("telegram_webhooks.commands.buy_inks.pack_title.#{pack_key}")
    end

    def description
      I18n.t("telegram_webhooks.commands.buy_inks.pack_description", credits: pack[:credits])
    end
  end
end
