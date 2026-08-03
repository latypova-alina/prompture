require "rails_helper"

describe StarsPayment::HandlePayment do
  describe ".organized" do
    it "organizes interactors in correct order" do
      expect(described_class.organized).to eq(
        [
          TokenHandler::FindOrCreateUser,
          StarsPayment::ResolvePack,
          StarsPayment::RecordPurchase,
          StarsPayment::GrantCredits,
          StarsPayment::NotifyUser
        ]
      )
    end
  end
end
