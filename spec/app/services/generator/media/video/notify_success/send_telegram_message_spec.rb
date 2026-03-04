require "rails_helper"

describe Generator::Media::Video::NotifySuccess::SendTelegramMessage do
  subject(:call_service) do
    described_class.call(reply_data:, request:)
  end

  let(:reply_data) { { text: "video ready" } }

  let(:request) do
    create(:button_video_processing_request)
  end

  let(:telegram_bot) { double }

  before do
    allow(::Telegram).to receive(:bot).and_return(telegram_bot)

    allow(telegram_bot)
      .to receive(:send_message)
  end

  describe ".call" do
    it "sends telegram message with reply data" do
      call_service

      expect(telegram_bot)
        .to have_received(:send_message)
        .with(chat_id: request.chat_id, **reply_data)
    end
  end
end
