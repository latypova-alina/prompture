require "rails_helper"

describe TelegramIntegration::DeleteBotTelegramMessage do
  subject(:call_service) { described_class.call(request:) }

  let(:request) { create(:button_image_processing_request) }
  let(:bot) { instance_double(Telegram::Bot::Client) }

  before do
    allow(Telegram).to receive(:bot).and_return(bot)
    allow(bot).to receive(:delete_message)
  end

  describe ".call" do
    context "when request is blank" do
      let(:request) { nil }

      it "does not call Telegram API" do
        call_service

        expect(bot).not_to have_received(:delete_message)
      end
    end

    context "when request has no bot telegram message" do
      it "does not call Telegram API" do
        call_service

        expect(bot).not_to have_received(:delete_message)
      end
    end

    context "when request has a bot telegram message" do
      let!(:bot_telegram_message) do
        create(:bot_telegram_message, request:, chat_id: request.chat_id, tg_message_id: 123)
      end

      it "deletes the telegram message and destroys the record" do
        call_service

        expect(bot)
          .to have_received(:delete_message)
          .with(chat_id: request.chat_id, message_id: 123)

        expect { bot_telegram_message.reload }
          .to raise_error(ActiveRecord::RecordNotFound)
      end

      context "when Telegram API raises an error" do
        before do
          allow(bot)
            .to receive(:delete_message)
            .and_raise(StandardError, "message not found")
        end

        it "still destroys the record" do
          call_service

          expect { bot_telegram_message.reload }
            .to raise_error(ActiveRecord::RecordNotFound)
        end
      end
    end
  end
end
