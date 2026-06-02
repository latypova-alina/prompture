require "rails_helper"

describe TelegramIntegration::DeleteAdminProcessingMessage do
  subject(:call_service) { described_class.call(user:) }

  let(:user) { create(:user) }
  let(:bot) { instance_double(Telegram::Bot::Client) }

  before do
    allow(Telegram).to receive(:bot).and_return(bot)
    allow(bot).to receive(:delete_message)
  end

  describe ".call" do
    context "when user has no processing message" do
      it "does not call Telegram API" do
        call_service

        expect(bot).not_to have_received(:delete_message)
      end
    end

    context "when user has a processing message" do
      let!(:bot_telegram_message) do
        create(:bot_telegram_message, request: user, chat_id: user.chat_id, tg_message_id: 123)
      end

      it "deletes the telegram message and destroys the record" do
        call_service

        expect(bot)
          .to have_received(:delete_message)
          .with(chat_id: user.chat_id, message_id: 123)

        expect { bot_telegram_message.reload }
          .to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
