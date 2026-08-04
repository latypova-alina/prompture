module StarsPayment
  class PackPresenter
    def initialize(pack_key:, pack:, locale:, invoice_url:)
      @pack_key = pack_key
      @pack = pack
      @locale = locale
      @invoice_url = invoice_url
    end

    def to_h
      {
        key: pack_key,
        credits: pack[:credits],
        stars: pack[:stars],
        title:,
        description:,
        estimate:,
        invoice_url:
      }
    end

    private

    attr_reader :pack_key, :pack, :locale, :invoice_url

    def title
      I18n.t("telegram_webhooks.commands.buy_inks.pack_title.#{pack_key}", locale:)
    end

    def description
      I18n.t("telegram_webhooks.commands.buy_inks.pack_description", credits: pack[:credits], locale:)
    end

    def estimate
      I18n.t("mini_app.buy_inks.pack_estimate.#{pack_key}", locale:)
    end
  end
end
