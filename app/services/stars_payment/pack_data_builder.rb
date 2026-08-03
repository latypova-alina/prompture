module StarsPayment
  class PackDataBuilder
    def initialize(locale:)
      @locale = locale
    end

    def pack_data
      packs.map do |pack_key, pack|
        invoice_url = InvoiceBuilder.new(pack_key:, pack:).invoice_url

        PackPresenter.new(pack_key:, pack:, locale:, invoice_url:).to_h
      end
    end

    private

    attr_reader :locale

    def packs
      CREDIT_PACKS
    end
  end
end
