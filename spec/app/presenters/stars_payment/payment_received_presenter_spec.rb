require "rails_helper"

describe StarsPayment::PaymentReceivedPresenter do
  subject { described_class.new(credits:, balance:, locale:).text }

  let(:credits) { 50 }
  let(:balance) { 52 }
  let(:locale) { "en" }

  it do
    is_expected.to eq(
      "🎉 Payment received! 50 stones 🪨 have been added to your balance.\nYour current balance is 52 stones 🪨."
    )
  end

  context "when the balance is 1" do
    let(:credits) { 1 }
    let(:balance) { 1 }

    it { is_expected.to end_with("Your current balance is 1 stone 🪨.") }
    it { is_expected.to start_with("🎉 Payment received! 1 stone 🪨 has been added to your balance.") }
  end

  context "when the locale is ru" do
    let(:locale) { "ru" }

    it { is_expected.to end_with(I18n.t("telegram_webhooks.commands.balance", balance: 52, count: 52, locale: :ru)) }
    it { is_expected.to end_with("Текущий баланс: 52 камня 🪨.") }

    context "with a balance of 1" do
      let(:balance) { 1 }

      it { is_expected.to end_with("Текущий баланс: 1 камень 🪨.") }
    end
  end
end
