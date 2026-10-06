require "rails_helper"

describe ErrorReplyMarkup do
  subject { described_class.call(error:, user:, locale: "en") }

  let(:user) { create(:user) }
  let(:error) { InsufficientCreditsError.new }

  before { Flipper.enable_actor(:flipper_stars_payments, user) }

  it { is_expected.to eq(inline_keyboard: [[StarsPayment::OpenStoreButton.call(locale: "en")]]) }

  context "when stars payments are disabled for the user" do
    before { Flipper.disable(:flipper_stars_payments) }

    it { is_expected.to be_nil }
  end

  context "when the error has no reply markup" do
    let(:error) { ModerationError.new }

    it { is_expected.to be_nil }
  end
end
