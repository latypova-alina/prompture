require "rails_helper"

describe StarsPayment::CommandHandlerPresenter do
  subject(:presenter) { described_class.new(locale:) }

  let(:locale) { "ru" }

  before do
    allow(Rails.env).to receive(:production?).and_return(false)
    stub_const("ENV", ENV.to_hash.merge("GENERATOR_WEBHOOK_BASE_URL" => "http://localhost:3000"))
  end

  describe "#formatted_text" do
    it { expect(presenter.formatted_text).to eq(I18n.t("telegram_webhooks.commands.buy_inks.ask", locale:)) }
  end

  describe "#inline_keyboard" do
    it "returns a single button opening the Mini App" do
      expect(presenter.inline_keyboard).to eq(
        [[
          {
            text: I18n.t("telegram_webhooks.commands.buy_inks.open_store_button", locale:),
            web_app: { url: "http://localhost:3000/mini_app/buy_inks" }
          }
        ]]
      )
    end
  end
end
