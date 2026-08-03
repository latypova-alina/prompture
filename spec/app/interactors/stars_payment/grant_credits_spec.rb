require "rails_helper"

describe StarsPayment::GrantCredits do
  subject(:result) { described_class.call(user:, stars_purchase:, newly_recorded:) }

  let(:user) { create(:user) }
  let(:stars_purchase) { create(:stars_purchase, user:, credits_amount: 250) }

  describe "#call" do
    context "when newly recorded" do
      let(:newly_recorded) { true }

      it "calls Billing::CreditsGranter with correct arguments" do
        expect(Billing::CreditsGranter).to receive(:call).with(
          user:,
          amount: stars_purchase.credits_amount,
          source: stars_purchase
        )

        result
      end

      it "is successful" do
        allow(Billing::CreditsGranter).to receive(:call)

        expect(result).to be_success
      end
    end

    context "when not newly recorded (replayed update)" do
      let(:newly_recorded) { false }

      it "does not grant credits again" do
        expect(Billing::CreditsGranter).not_to receive(:call)

        result
      end

      it "is successful" do
        expect(result).to be_success
      end
    end
  end
end
