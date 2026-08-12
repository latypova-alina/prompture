require "rails_helper"

describe StarsPayment::InvoiceBuilder do
  subject(:invoice_url) { described_class.new(pack_key:, pack:).invoice_url }

  let(:pack_key) { "medium" }
  let(:pack) { CREDIT_PACKS[:medium] }

  let(:bot) { instance_double(Telegram::Bot::Client) }
  let(:result_url) { "https://t.me/$abc123" }
  let(:title) { I18n.t("telegram_webhooks.commands.buy_stones.pack_title.medium") }

  before do
    allow(Telegram).to receive(:bot).and_return(bot)
    allow(bot).to receive(:create_invoice_link).and_return({ "ok" => true, "result" => result_url })
  end

  describe "#invoice_url" do
    it "requests an invoice link with the correct arguments" do
      expect(bot).to receive(:create_invoice_link).with(
        title:,
        description: I18n.t("telegram_webhooks.commands.buy_stones.pack_description", credits: pack[:credits]),
        payload: "medium",
        provider_token: "",
        currency: "XTR",
        prices: [{ label: title, amount: pack[:stars] }]
      )

      invoice_url
    end

    it "returns the invoice url from the response" do
      expect(invoice_url).to eq(result_url)
    end
  end
end
