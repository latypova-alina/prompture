require "rails_helper"

describe Generator::Media::Video::CancellationNotifierJob do
  subject(:perform_job) { described_class.new.perform(button_request.id) }

  let(:button_request) { create(:button_video_processing_request, status: "PENDING") }
  let(:telegram_bot) { double }
  let(:processor_name) { button_request.humanized_process_name }

  before do
    allow(Telegram).to receive(:bot).and_return(telegram_bot)
    allow(telegram_bot).to receive(:send_message)
  end

  context "when parent request has bot telegram message" do
    before do
      create(:bot_telegram_message, request: button_request.parent_request, tg_message_id: 123_456)
    end

    it "sends cancellation message with reply_to_message_id" do
      expect(telegram_bot).to receive(:send_message).with(
        chat_id: button_request.chat_id,
        text: I18n.t("errors.generation_cancelled_successfully", processor_name:),
        reply_to_message_id: 123_456
      )

      perform_job
    end

    it "updates request status to CANCELLED" do
      perform_job

      expect(button_request.reload.status).to eq("CANCELLED")
    end
  end

  context "when parent request has no bot telegram message" do
    it "sends cancellation message without reply_to_message_id" do
      expect(telegram_bot).to receive(:send_message).with(
        chat_id: button_request.chat_id,
        text: I18n.t("errors.generation_cancelled_successfully", processor_name:)
      )

      perform_job
    end
  end
end
