require "rails_helper"

describe NewUserBonus::NotifyUser do
  subject(:call) { described_class.call(chat_id:) }

  let(:chat_id) { 456 }

  describe "#call" do
    it "sends the welcome bonus message via Telegram" do
      expect(Telegram.bot).to receive(:send_message).with(
        chat_id:,
        text: I18n.t("telegram_webhooks.commands.start.welcome_bonus")
      )

      call
    end

    it "is successful" do
      allow(Telegram.bot).to receive(:send_message)

      expect(call).to be_success
    end
  end
end
