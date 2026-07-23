require "rails_helper"

describe MediaGenerator::ButtonHandler::ForBloomy::ShortComplexScript::CreditsValidator do
  subject { described_class.new(user:, total_cost: 12).enough_credits? }

  context "when balance covers the total cost" do
    let(:user) { create(:user, :with_custom_balance, credits: 12) }

    it { is_expected.to be(true) }
  end

  context "when balance is insufficient" do
    let(:user) { create(:user, :with_custom_balance, credits: 5) }

    it { is_expected.to be(false) }
  end
end
