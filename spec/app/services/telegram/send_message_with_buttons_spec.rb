require "rails_helper"

describe Telegram::SendMessageWithButtons do
  subject { described_class.call(chat_id:, reply_data:, request: request_record) }

  let(:chat_id) { 456 }
  let(:reply_data) do
    {
      text: "Hello",
      reply_markup: { inline_keyboard: [] }
    }
  end

  let(:request_record) { create(:prompt_message) }

  let(:bot) { instance_double(Telegram::Bot::Client) }

  let(:telegram_response) do
    {
      "ok" => true,
      "result" => {
        "message_id" => 777
      }
    }
  end

  before do
    allow(Telegram).to receive(:bot).and_return(bot)
    allow(bot).to receive(:send_message).and_return(telegram_response)
  end

  describe ".call" do
    it "calls Telegram.bot.send_message with correct arguments" do
      expect(bot)
        .to receive(:send_message)
        .with(chat_id: chat_id, **reply_data)

      subject
    end

    it "creates a TelegramMessage record" do
      expect { subject }
        .to change(TelegramMessage, :count).by(1)

      record = TelegramMessage.last

      expect(record.tg_message_id).to eq(777)
      expect(record.chat_id).to eq(chat_id)
      expect(record.request).to eq(request_record)
    end
  end
end
