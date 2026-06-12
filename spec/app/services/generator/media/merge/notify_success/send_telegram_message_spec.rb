require "rails_helper"

describe Generator::Media::Merge::NotifySuccess::SendTelegramMessage do
  subject(:call_service) do
    described_class.call(reply_data:, request:)
  end

  let(:reply_data) { { text: "merge ready" } }
  let(:audio_request) { create(:button_audio_processing_request, :completed) }
  let(:request) do
    create(:button_merge_audio_video_processing_request, parent_request: audio_request)
  end

  before do
    allow(TelegramIntegration::SendMessageWithButtons)
      .to receive(:call)
  end

  describe ".call" do
    context "when source telegram message exists on an ancestor request" do
      before do
        create(:bot_telegram_message, request: audio_request.parent_request, tg_message_id: 123_456)
      end

      it "sends telegram message as reply" do
        call_service

        expect(TelegramIntegration::SendMessageWithButtons)
          .to have_received(:call)
          .with(
            reply_data: reply_data.merge(reply_to_message_id: 123_456),
            request:
          )
      end
    end

    context "when source telegram message does not exist" do
      it "sends telegram message without reply reference" do
        call_service

        expect(TelegramIntegration::SendMessageWithButtons)
          .to have_received(:call)
          .with(
            reply_data:,
            request:
          )
      end

      it "does not mutate original reply_data hash" do
        call_service

        expect(reply_data).to eq(text: "merge ready")
      end
    end
  end
end
