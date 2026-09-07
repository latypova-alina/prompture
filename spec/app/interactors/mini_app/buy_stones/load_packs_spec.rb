require "rails_helper"

describe MiniApp::BuyStones::LoadPacks do
  describe ".organized" do
    it "organizes interactors in correct order" do
      expect(described_class.organized).to eq(
        [
          MiniApp::BuyStones::ValidateInitData,
          MiniApp::BuyStones::ResolveUser,
          MiniApp::BuyStones::AcceptTerms,
          MiniApp::BuyStones::BuildPackData
        ]
      )
    end
  end
end
