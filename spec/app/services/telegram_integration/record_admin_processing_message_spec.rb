require "rails_helper"

describe TelegramIntegration::RecordAdminProcessingMessage do
  subject(:call_service) { described_class.call(response:, user:) }

  let(:user) { create(:user) }
  let(:response) do
    {
      "ok" => true,
      "result" => {
        "message_id" => 777
      }
    }
  end

  describe ".call" do
    it "creates a BotTelegramMessage record on the user" do
      expect { call_service }
        .to change(BotTelegramMessage, :count).by(1)

      record = BotTelegramMessage.last

      expect(record.tg_message_id).to eq(777)
      expect(record.chat_id).to eq(user.chat_id)
      expect(record.request).to eq(user)
    end

    context "when user already has a processing message" do
      let(:bot) { instance_double(Telegram::Bot::Client) }

      before do
        create(:bot_telegram_message, request: user, chat_id: user.chat_id, tg_message_id: 111)
        allow(Telegram).to receive(:bot).and_return(bot)
        allow(bot).to receive(:delete_message)
      end

      it "replaces the previous processing message record" do
        call_service

        expect(user.reload.bot_telegram_message.tg_message_id).to eq(777)
        expect(BotTelegramMessage.where(request: user).count).to eq(1)
      end
    end
  end
end
