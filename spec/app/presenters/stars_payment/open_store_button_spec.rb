require "rails_helper"

describe StarsPayment::OpenStoreButton do
  subject { described_class.call(locale: "ru") }

  before do
    allow(Rails.env).to receive(:production?).and_return(false)
    stub_const("ENV", ENV.to_hash.merge("GENERATOR_WEBHOOK_BASE_URL" => "http://localhost:3000"))
  end

  it do
    is_expected.to eq(
      text: I18n.t("telegram_webhooks.commands.buy_stones.open_store_button", locale: "ru"),
      web_app: { url: "http://localhost:3000/mini_app/buy_stones" }
    )
  end
end
