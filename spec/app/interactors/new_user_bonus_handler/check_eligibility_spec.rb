require "rails_helper"

describe NewUserBonusHandler::CheckEligibility do
  subject(:call) { described_class.call(user:, token_code:) }

  let(:user) { create(:user) }
  let(:token_code) { nil }

  before do
    allow(Flipper).to receive(:enabled?).with(:flipper_welcome_bonus, user).and_return(true)
  end

  context "when user is newly created, no token_code, and flag enabled" do
    before { allow(user).to receive(:previously_new_record?).and_return(true) }

    it "is successful" do
      expect(call).to be_success
    end
  end

  context "when token_code is present" do
    let(:token_code) { "XXX" }

    before { allow(user).to receive(:previously_new_record?).and_return(true) }

    it "fails" do
      expect(call).to be_failure
    end
  end

  context "when user was not newly created" do
    before { allow(user).to receive(:previously_new_record?).and_return(false) }

    it "fails" do
      expect(call).to be_failure
    end
  end

  context "when flag is disabled" do
    before do
      allow(user).to receive(:previously_new_record?).and_return(true)
      allow(Flipper).to receive(:enabled?).with(:flipper_welcome_bonus, user).and_return(false)
    end

    it "fails" do
      expect(call).to be_failure
    end
  end
end
