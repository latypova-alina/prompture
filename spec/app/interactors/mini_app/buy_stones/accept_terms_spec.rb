require "rails_helper"

describe MiniApp::BuyStones::AcceptTerms do
  subject(:result) { described_class.call(user:, terms_accepted:) }

  let(:user) { create(:user) }

  describe "#call" do
    context "when terms_accepted is false" do
      let(:terms_accepted) { false }

      it "does not record acceptance" do
        expect { result }.not_to(change { user.reload.terms_accepted_at })
      end
    end

    context "when terms_accepted is true and the user has not accepted yet" do
      let(:terms_accepted) { true }

      it "records acceptance" do
        expect { result }.to change { user.reload.terms_accepted_at }.from(nil)
      end
    end

    context "when terms_accepted is true but the user already accepted" do
      let(:terms_accepted) { true }
      let(:user) { create(:user, :terms_accepted) }

      it "does not overwrite the original timestamp" do
        expect { result }.not_to(change { user.reload.terms_accepted_at })
      end
    end
  end
end
