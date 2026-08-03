require "rails_helper"

describe SuccessfulPayment do
  let(:payment) do
    described_class.new(
      {
        "invoice_payload" => "medium",
        "telegram_payment_charge_id" => "charge_abc",
        "total_amount" => 450
      }
    )
  end

  describe "#pack_key" do
    it { expect(payment.pack_key).to eq("medium") }
  end

  describe "#telegram_payment_charge_id" do
    it { expect(payment.telegram_payment_charge_id).to eq("charge_abc") }
  end

  describe "#stars_amount" do
    it { expect(payment.stars_amount).to eq(450) }
  end
end
