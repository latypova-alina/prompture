require "rails_helper"

describe TokenHandler::HandleToken do
  describe ".organized" do
    it "organizes interactors in correct order" do
      expect(described_class.organized).to eq(
        [
          TokenHandler::FindOrCreateUser,
          TokenHandler::VerifyToken,
          TokenHandler::UpdateToken,
          TokenHandler::GrantCredits,
          TokenHandler::NotifyUser
        ]
      )
    end
  end
end
