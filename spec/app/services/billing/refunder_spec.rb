require "rails_helper"

describe Billing::Refunder do
  subject(:call) { described_class.call(user:, amount:, source:) }

  let(:user) { create(:user) }
  let!(:balance) { create(:balance, user:, credits: 100) }
  let(:source) { create(:token) }
  let(:amount) { 30 }

  describe ".call" do
    context "when amount is valid" do
      it "increments the balance" do
        expect { call }
          .to change { balance.reload.credits }
          .from(100).to(130)
      end

      it "creates a refund transaction" do
        expect { call }
          .to change(BalanceTransaction, :count).by(1)

        tx = BalanceTransaction.last

        expect(tx.user).to eq(user)
        expect(tx.transaction_type).to eq("REFUND")
        expect(tx.amount).to eq(amount)
        expect(tx.source).to eq(source)
      end
    end

    context "when amount is zero or negative" do
      let(:amount) { 0 }

      it "raises ArgumentError" do
        expect { call }
          .to raise_error(ArgumentError, "Amount must be positive")
      end
    end

    context "when transaction already exists (RecordNotUnique)" do
      before do
        allow(BalanceTransaction)
          .to receive(:find_or_create_by!)
          .and_raise(ActiveRecord::RecordNotUnique)
      end

      it "returns nil" do
        expect(call).to be_nil
      end
    end
  end
end
