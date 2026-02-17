require "rails_helper"

describe Billing::CreditsGranter do
  subject(:call) { described_class.call(user:, amount:, source:) }

  let(:user) { create(:user) }
  let(:source) { create(:token) }
  let(:amount) { 50 }

  describe ".call" do
    context "when user already has a balance" do
      let!(:balance) { create(:balance, user:, credits: 100) }

      it "increments the balance" do
        expect { call }
          .to change { balance.reload.credits }
          .from(100).to(150)
      end

      it "creates a GRANT transaction" do
        expect { call }
          .to change(BalanceTransaction, :count).by(1)

        tx = BalanceTransaction.last

        expect(tx.transaction_type).to eq("GRANT")
        expect(tx.amount).to eq(amount)
        expect(tx.user).to eq(user)
        expect(tx.source).to eq(source)
      end
    end

    context "when user does not have a balance" do
      it "creates a balance" do
        expect { call }
          .to change(Balance, :count).by(1)
      end

      it "sets initial credits to granted amount" do
        call

        balance = user.reload.balance
        expect(balance.credits).to eq(amount)
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
