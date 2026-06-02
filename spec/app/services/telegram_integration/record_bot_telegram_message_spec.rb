require "rails_helper"

describe TelegramIntegration::RecordBotTelegramMessage do
  subject(:call_service) { described_class.call(response:, request:) }

  let(:request) { create(:button_image_processing_request) }
  let(:response) do
    {
      "ok" => true,
      "result" => {
        "message_id" => 777
      }
    }
  end

  describe ".call" do
    it "creates a BotTelegramMessage record" do
      expect { call_service }
        .to change(BotTelegramMessage, :count).by(1)

      record = BotTelegramMessage.last

      expect(record.tg_message_id).to eq(777)
      expect(record.chat_id).to eq(request.chat_id)
      expect(record.request).to eq(request)
    end
  end
end
