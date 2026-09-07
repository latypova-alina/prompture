require "rails_helper"

describe MiniApp::CurrentPolicyAcceptance do
  subject(:current_policy_acceptance) { described_class.new(user:) }

  let(:user) { create(:user) }

  describe "#present?" do
    context "when the user has never accepted any policy version" do
      it { expect(current_policy_acceptance.present?).to eq(false) }
    end

    context "when the user's latest acceptance matches the current policy versions" do
      before { create(:policy_acceptance, user:) }

      it { expect(current_policy_acceptance.present?).to eq(true) }
    end

    context "when the user's latest acceptance is for an outdated privacy policy version" do
      before do
        create(:policy_acceptance, user:, privacy_policy_version: "2020-01-01",
                                   terms_version: POLICY_VERSIONS[:terms_of_use])
      end

      it { expect(current_policy_acceptance.present?).to eq(false) }
    end

    context "when the user's latest acceptance is for an outdated terms version" do
      before do
        create(:policy_acceptance, user:, privacy_policy_version: POLICY_VERSIONS[:privacy_policy],
                                   terms_version: "2020-01-01")
      end

      it { expect(current_policy_acceptance.present?).to eq(false) }
    end

    context "when an outdated acceptance is followed by a current one" do
      before do
        create(:policy_acceptance, user:, privacy_policy_version: "2020-01-01", terms_version: "2020-01-01",
                                   accepted_at: 1.day.ago)
        create(:policy_acceptance, user:, accepted_at: Time.current)
      end

      it "checks only the latest acceptance" do
        expect(current_policy_acceptance.present?).to eq(true)
      end
    end
  end
end
