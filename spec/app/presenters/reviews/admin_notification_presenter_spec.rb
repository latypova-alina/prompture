require "rails_helper"

describe Reviews::AdminNotificationPresenter do
  subject(:text) { described_class.new(review).text }

  let(:user) { create(:user, name: "Alina") }
  let(:review) do
    create(:review, user:, rating: 4, answers: attributes_for(:review)[:answers].merge("missing" => "a" * 300))
  end

  it { is_expected.to start_with("📝 New review from Alina (user #{user.id}): ⭐⭐⭐⭐ 4/5") }
  it { is_expected.to include("What's missing in the bot?\n#{'a' * 197}...") }
  it { is_expected.to end_with("https://admin.caivemanator.com/users/#{user.id}") }

  it { is_expected.not_to include("Granted") }

  context "when the review was rewarded" do
    before { Billing::CreditsGranter.call(user:, amount: 50, source: review) }

    it { is_expected.to include("🎁 Granted 50 stones for this review") }
  end
end
