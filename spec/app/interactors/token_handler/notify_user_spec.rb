require "rails_helper"

describe TokenHandler::NotifyUser do
  subject { described_class.call(chat_id:, token:) }

  let(:chat_id) { 456 }
  let(:token) { create(:token, greeting: "Welcome!", credits: 100) }

  describe "#call" do
    it "sends greeting and activated message via Telegram" do
      activated_text =
        I18n.t(
          "telegram_webhooks.commands.activate_token.activated",
          credits: token.credits
        )

      expected_text = "Welcome!\n\n#{activated_text}"

      expect(Telegram.bot).to receive(:send_message).with(
        chat_id:,
        text: expected_text
      )

      subject
    end

    it "is successful" do
      allow(Telegram.bot).to receive(:send_message)

      expect(subject).to be_success
    end

    context "when greeting is nil" do
      let(:token) { create(:token, greeting: nil, credits: 100) }

      it "sends default activated message" do
        activated_text =
          I18n.t(
            "telegram_webhooks.commands.activate_token.activated",
            credits: token.credits
          )

        expect(Telegram.bot).to receive(:send_message).with(
          chat_id:,
          text: activated_text
        )

        subject
      end
    end
  end
end
