require "rails_helper"

describe MiniApp::BuyStones::AcceptTerms do
  subject(:result) { described_class.call(user:, terms_accepted:) }

  let(:user) { create(:user) }

  describe "#call" do
    context "when terms_accepted is false" do
      let(:terms_accepted) { false }

      it "does not record acceptance" do
        expect { result }.not_to change(PolicyAcceptance, :count)
      end
    end

    context "when terms_accepted is true and the user has not accepted yet" do
      let(:terms_accepted) { true }

      it "records acceptance with the current policy versions" do
        expect { result }.to change { user.policy_acceptances.count }.by(1)

        expect(user.policy_acceptances.last).to have_attributes(
          privacy_policy_version: POLICY_VERSIONS[:privacy_policy],
          terms_version: POLICY_VERSIONS[:terms_of_use]
        )
      end
    end

    context "when terms_accepted is true but the user already accepted the current versions" do
      let(:terms_accepted) { true }
      let!(:user) { create(:user, :terms_accepted) }

      it "does not record a new acceptance" do
        expect { result }.not_to change(PolicyAcceptance, :count)
      end
    end

    context "when the user's latest acceptance is for outdated policy versions" do
      let(:terms_accepted) { true }

      before do
        create(:policy_acceptance, user:, privacy_policy_version: "2020-01-01", terms_version: "2020-01-01")
      end

      it "records a new acceptance for the current versions" do
        expect { result }.to change { user.policy_acceptances.count }.by(1)

        expect(user.policy_acceptances.order(:accepted_at).last).to have_attributes(
          privacy_policy_version: POLICY_VERSIONS[:privacy_policy],
          terms_version: POLICY_VERSIONS[:terms_of_use]
        )
      end
    end
  end
end
