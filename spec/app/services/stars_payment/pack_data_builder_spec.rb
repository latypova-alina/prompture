require "rails_helper"

describe StarsPayment::PackDataBuilder do
  subject(:pack_data) { described_class.new(locale:).pack_data }

  let(:locale) { "ru" }
  let(:invoice_url) { "https://t.me/$test" }

  before do
    allow(StarsPayment::InvoiceBuilder).to receive(:new).and_return(double(invoice_url:))
  end

  describe "#pack_data" do
    it "returns a pack for each configured pack" do
      expect(pack_data.map { |p| p[:key] }).to match_array(CREDIT_PACKS.keys)
    end

    it "returns the invoice url from StarsPayment::InvoiceBuilder" do
      expect(pack_data).to all(include(invoice_url:))
    end

    it "localizes the pack title using the given locale" do
      small_pack = pack_data.find { |p| p[:key] == :small }
      expected_title = I18n.t("telegram_webhooks.commands.buy_credits.pack_title.small", locale: "ru")

      expect(small_pack[:title]).to eq(expected_title)
    end

    it "includes credits and stars from CREDIT_PACKS" do
      medium_pack = pack_data.find { |p| p[:key] == :medium }

      expect(medium_pack).to include(
        credits: CREDIT_PACKS[:medium][:credits],
        stars: CREDIT_PACKS[:medium][:stars]
      )
    end
  end
end
