require "rails_helper"

describe StarsPayment::NotifyUser do
  subject(:result) { described_class.call(chat_id:, stars_purchase:, newly_recorded:) }

  let(:chat_id) { 456 }
  let(:stars_purchase) { create(:stars_purchase, credits_amount: 250) }

  let(:bot) { instance_double(Telegram::Bot::Client) }

  let(:expected_text) do
    I18n.t(
      "telegram_webhooks.commands.buy_credits.thank_you",
      credits: stars_purchase.credits_amount,
      count: stars_purchase.credits_amount
    )
  end

  before do
    allow(Telegram).to receive(:bot).and_return(bot)
    allow(bot).to receive(:send_message)
  end

  describe "#call" do
    context "when newly recorded" do
      let(:newly_recorded) { true }

      it "sends the thank you message via Telegram" do
        expect(bot).to receive(:send_message).with(chat_id:, text: expected_text)

        result
      end

      it "is successful" do
        expect(result).to be_success
      end
    end

    context "when not newly recorded (replayed update)" do
      let(:newly_recorded) { false }

      it "does not send a message" do
        expect(bot).not_to receive(:send_message)

        result
      end
    end
  end
end
