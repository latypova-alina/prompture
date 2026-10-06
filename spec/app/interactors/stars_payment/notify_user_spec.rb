require "rails_helper"

describe StarsPayment::NotifyUser do
  subject(:result) { described_class.call(chat_id:, user:, locale: "en", stars_purchase:, newly_recorded:) }

  let(:chat_id) { 456 }
  let(:user) { create(:user, chat_id:).tap { |user| create(:balance, user:, credits: 2) } }
  let(:stars_purchase) { create(:stars_purchase, user:, credits_amount: 50) }
  let(:newly_recorded) { true }

  let(:bot) { instance_double(Telegram::Bot::Client, send_message: true) }

  before do
    allow(Telegram).to receive(:bot).and_return(bot)
    Billing::CreditsGranter.call(user:, amount: 50, source: stars_purchase)
  end

  it { is_expected.to be_success }

  it "sends the credited amount and the balance after the purchase" do
    result

    expect(bot).to have_received(:send_message).with(
      chat_id:,
      text: "🎉 Payment received! 50 stones 🪨 have been added to your balance.\nYour current balance is 52 stones 🪨."
    )
  end

  context "when the user had no balance before the purchase" do
    let(:user) { create(:user, chat_id:) }

    it "shows the balance the purchase created" do
      result

      expect(bot).to have_received(:send_message).with(chat_id:, text: end_with("Your current balance is 50 stones 🪨."))
    end
  end

  context "when not newly recorded (replayed update)" do
    let(:newly_recorded) { false }

    it "does not send a message" do
      result

      expect(bot).not_to have_received(:send_message)
    end
  end
end
