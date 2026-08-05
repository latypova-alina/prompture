require "rails_helper"

describe NewUserBonusHandler::GrantBonus do
  subject(:call) { described_class.call(user:) }

  let(:user) { create(:user) }

  describe "#call" do
    it "creates a welcome bonus for the user" do
      expect { call }.to change(WelcomeBonus, :count).by(1)
      expect(WelcomeBonus.last.user).to eq(user)
    end

    it "grants credits via Billing::CreditsGranter" do
      expect(Billing::CreditsGranter).to receive(:call).with(
        user:,
        amount: NewUserBonusHandler::GrantBonus::CREDITS_AMOUNT,
        source: instance_of(WelcomeBonus)
      )

      call
    end

    context "when a concurrent request already took the same slot number" do
      before do
        allow(WelcomeBonus).to receive(:create!) do
          raise PG::UniqueViolation, "duplicate key"
        rescue PG::UniqueViolation
          raise ActiveRecord::RecordNotUnique, "duplicate key"
        end
      end

      it "fails without raising" do
        expect(call).to be_failure
      end

      it "does not grant credits" do
        expect(Billing::CreditsGranter).not_to receive(:call)

        call
      end
    end

    context "when the 100-bonus cap is already reached" do
      before { 100.times { create(:welcome_bonus) } }

      it "fails" do
        expect(call).to be_failure
      end

      it "does not grant credits" do
        expect(Billing::CreditsGranter).not_to receive(:call)

        call
      end

      it "does not create an extra welcome bonus" do
        expect { call }.not_to change(WelcomeBonus, :count)
      end
    end
  end
end
