module StarsPayment
  class PackDataBuilder
    def initialize(locale:, include_invoice:)
      @locale = locale
      @include_invoice = include_invoice
    end

    def pack_data
      packs.map do |pack_key, pack|
        invoice_url = build_invoice_url(pack_key:, pack:)

        PackPresenter.new(pack_key:, pack:, locale:, invoice_url:).to_h
      end
    end

    private

    attr_reader :locale, :include_invoice

    def build_invoice_url(pack_key:, pack:)
      return unless include_invoice

      InvoiceBuilder.new(pack_key:, pack:).invoice_url
    end

    def packs
      CREDIT_PACKS
    end
  end
end
