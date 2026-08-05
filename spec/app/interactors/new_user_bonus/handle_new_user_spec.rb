require "rails_helper"

describe NewUserBonus::HandleNewUser do
  describe ".organized" do
    it "organizes interactors in correct order" do
      expect(described_class.organized).to eq(
        [
          NewUserBonus::CheckEligibility,
          NewUserBonus::GrantBonus,
          NewUserBonus::NotifyUser
        ]
      )
    end
  end
end
