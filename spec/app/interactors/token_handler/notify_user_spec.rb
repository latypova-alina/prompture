require "rails_helper"

describe TokenHandler::NotifyUser do
  subject { described_class.call(chat_id:, token:) }

  let(:chat_id) { 456 }
  let(:token) { create(:token, greeting: "Welcome!") }

  describe "#call" do
    it "sends greeting message via Telegram" do
      expect(Telegram.bot).to receive(:send_message).with(
        chat_id: chat_id,
        text: "Welcome!"
      )

      subject
    end

    it "is successful" do
      allow(Telegram.bot).to receive(:send_message)

      expect(subject).to be_success
    end

    context "when greeting is nil" do
      let(:token) { create(:token, greeting: nil) }

      it "sends default start message" do
        default_text = I18n.t("telegram_webhooks.commands.start")

        expect(Telegram.bot).to receive(:send_message).with(
          chat_id: chat_id,
          text: default_text
        )

        subject
      end
    end
  end
end
