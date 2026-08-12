require "rails_helper"

describe StarsPayment::PackPresenter do
  subject(:pack_hash) { described_class.new(pack_key:, pack:, locale:, invoice_url:).to_h }

  let(:pack_key) { :medium }
  let(:pack) { CREDIT_PACKS[:medium] }
  let(:locale) { "ru" }
  let(:invoice_url) { "https://t.me/$test" }

  describe "#to_h" do
    it "returns the pack key, credits, and stars" do
      expect(pack_hash).to include(key: :medium, credits: pack[:credits], stars: pack[:stars])
    end

    it "localizes the title, description, and estimate using the given locale" do
      expected_description = I18n.t(
        "telegram_webhooks.commands.buy_stones.pack_description",
        credits: pack[:credits],
        locale:
      )

      expect(pack_hash).to include(
        title: I18n.t("telegram_webhooks.commands.buy_stones.pack_title.medium", locale:),
        description: expected_description,
        estimate: I18n.t("mini_app.buy_stones.pack_estimate.medium", locale:)
      )
    end

    it "includes the given invoice url" do
      expect(pack_hash).to include(invoice_url:)
    end
  end
end
