require "rails_helper"

describe Reviews::ThankYouPresenter do
  subject { described_class.new(locale:, reward_credits:, balance:).text }

  let(:locale) { "en" }
  let(:reward_credits) { 50 }
  let(:balance) { 52 }

  it do
    is_expected.to eq("🎉 Congratulations! Thank you for your review, 50 stones 🪨 have been added to your balance.\n" \
                      "Your current balance is 52 stones 🪨.")
  end

  context "when no reward was granted" do
    let(:reward_credits) { nil }
    let(:balance) { nil }

    it { is_expected.to eq(I18n.t("reviews.thank_you", locale: :en)) }
  end

  context "when the locale is ru" do
    let(:locale) { "ru" }

    it do
      is_expected.to eq("🎉 Поздравляем! Спасибо за отзыв, ваш баланс пополнен на 50 камней 🪨.\n" \
                        "Текущий баланс: 52 камня 🪨.")
    end

    context "with a balance of 1" do
      let(:balance) { 1 }

      it { is_expected.to end_with("Текущий баланс: 1 камень 🪨.") }
    end
  end
end
