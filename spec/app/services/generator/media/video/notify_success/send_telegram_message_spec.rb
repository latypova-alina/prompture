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
    context "when source telegram message exists" do
      before do
        create(:telegram_message, request: request.parent_request, tg_message_id: 123_456)
      end

      it "sends telegram message as reply" do
        call_service

        expect(telegram_bot)
          .to have_received(:send_message)
          .with(chat_id: request.chat_id, **reply_data.merge(reply_to_message_id: 123_456))
      end
    end

    context "when source telegram message does not exist" do
      it "sends telegram message without reply reference" do
        call_service

        expect(telegram_bot)
          .to have_received(:send_message)
          .with(chat_id: request.chat_id, **reply_data)
      end
    end

    context "when current request telegram message exists but parent message does not" do
      before do
        create(:telegram_message, request:, tg_message_id: 999_999)
      end

      it "sends telegram message without reply reference" do
        call_service

        expect(telegram_bot)
          .to have_received(:send_message)
          .with(chat_id: request.chat_id, **reply_data)
      end
    end
  end
end
