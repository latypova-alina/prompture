require "rails_helper"

describe TokenHandler::GrantCredits do
  subject { described_class.call(token:, user:) }

  let(:user) { create(:user) }
  let(:token) { create(:token, credits: 50) }

  describe "#call" do
    it "calls Billing::CreditsGranter with correct arguments" do
      expect(Billing::CreditsGranter).to receive(:call).with(
        user:,
        amount: token.credits,
        source: token
      )

      subject
    end

    it "is successful" do
      allow(Billing::CreditsGranter).to receive(:call)

      expect(subject).to be_success
    end

    context "when credits is zero" do
      let(:token) { create(:token, credits: 0) }

      it "still calls CreditsGranter with zero amount" do
        expect(Billing::CreditsGranter).to receive(:call).with(
          user:,
          amount: 0,
          source: token
        )

        subject
      end
    end
  end
end
