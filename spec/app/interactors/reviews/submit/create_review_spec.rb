require "rails_helper"

describe Reviews::Submit::CreateReview do
  subject(:result) { described_class.call(user:, locale: "en", normalized_answers:) }

  let(:user) { create(:user).tap { |user| create(:balance, user:, credits: 2) } }
  let(:normalized_answers) { attributes_for(:review)[:answers] }

  context "when the review bonus is off" do
    it { is_expected.to be_success }
    it { expect { result }.to change(Review, :count).by(1) }
    it { expect { result }.not_to change(BalanceTransaction, :count) }
    it { expect(result.reward_credits).to be_nil }
  end

  context "when the review bonus is on" do
    before { Flipper.enable_actor(:flipper_review_bonus, user) }

    it { expect { result }.to change(Review, :count).by(1) }
    it { expect { result }.to change { user.balance.reload.credits }.from(2).to(52) }
    it { expect(result.reward_credits).to eq(50) }

    it "records a 50 stone grant sourced from the review" do
      expect(BalanceTransaction.find_by!(source: result.review))
        .to have_attributes(transaction_type: "GRANT", amount: 50, user:)
    end

    context "when the user already has a review (concurrent submit)" do
      before { create(:review, user:) }

      it { expect(result.error).to eq(Reviews::AlreadyReviewedError) }
      it { expect { result }.not_to change(Review, :count) }
      it { expect { result }.not_to change(BalanceTransaction, :count) }
      it { expect { result }.not_to(change { user.balance.reload.credits }) }
    end

    context "when the grant fails" do
      before { allow(Billing::CreditsGranter).to receive(:call).and_raise(ActiveRecord::RecordInvalid) }

      it { expect { result }.to raise_error(ActiveRecord::RecordInvalid) }

      it "rolls the review back too" do
        expect do
          result
        rescue ActiveRecord::RecordInvalid
          nil
        end.not_to change(Review, :count)
      end
    end
  end
end
