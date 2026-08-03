require "rails_helper"

describe StarsPayment::RecordPurchase do
  subject(:result) do
    described_class.call(
      user:,
      pack:,
      pack_key:,
      telegram_payment_charge_id:,
      stars_amount:
    )
  end

  let(:user) { create(:user) }
  let(:pack_key) { "medium" }
  let(:pack) { CREDIT_PACKS[:medium] }
  let(:telegram_payment_charge_id) { "charge_123" }
  let(:stars_amount) { pack[:stars] }

  describe "#call" do
    context "when purchase does not exist yet" do
      it "creates a StarsPurchase" do
        expect { result }.to change(StarsPurchase, :count).by(1)
      end

      it "sets the correct attributes" do
        purchase = result.stars_purchase

        expect(purchase).to have_attributes(
          user:,
          pack_key:,
          stars_amount:,
          credits_amount: pack[:credits]
        )
      end

      it "marks the purchase as newly recorded" do
        expect(result.newly_recorded).to be(true)
      end
    end

    context "when purchase already exists for this charge id" do
      let!(:existing_purchase) { create(:stars_purchase, telegram_payment_charge_id:, user:) }

      it "does not create a second purchase" do
        expect { result }.not_to change(StarsPurchase, :count)
      end

      it "returns the existing purchase" do
        expect(result.stars_purchase).to eq(existing_purchase)
      end

      it "marks the purchase as not newly recorded" do
        expect(result.newly_recorded).to be(false)
      end
    end
  end
end
