require "rails_helper"

describe NewUserBonusHandler::HandleNewUser do
  describe ".organized" do
    it "organizes interactors in correct order" do
      expect(described_class.organized).to eq(
        [
          NewUserBonusHandler::CheckEligibility,
          NewUserBonusHandler::GrantBonus,
          NewUserBonusHandler::NotifyUser
        ]
      )
    end
  end
end
