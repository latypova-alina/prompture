require "rails_helper"

describe Generator::Media::Image::ErrorNotifierJob do
  subject(:perform_job) { described_class.new.perform(button_request.id) }

  let(:button_request) { create(:button_image_processing_request, status: "PENDING") }

  let(:telegram_bot) { double }

  before do
    allow(Telegram).to receive(:bot).and_return(telegram_bot)
    allow(telegram_bot).to receive(:send_message)
    allow(telegram_bot).to receive(:delete_message)
  end

  describe "#perform" do
    context "when button request has a processing bot telegram message" do
      let!(:processing_message) do
        create(:bot_telegram_message, request: button_request, tg_message_id: 999)
      end

      it "deletes the processing message before sending the error" do
        perform_job

        expect(telegram_bot)
          .to have_received(:delete_message)
          .with(chat_id: button_request.chat_id, message_id: 999)

        expect { processing_message.reload }
          .to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context "when parent request has bot telegram message" do
      before do
        create(:bot_telegram_message, request: button_request.parent_request, tg_message_id: 123_456)
      end

      it "sends telegram message with reply_to_message_id" do
        expect(telegram_bot).to receive(:send_message).with(
          chat_id: button_request.chat_id,
          text: I18n.t("errors.image_generating_error"),
          reply_to_message_id: 123_456
        )

        perform_job
      end
    end

    context "when parent request has no bot telegram message" do
      it "sends telegram message without reply_to_message_id" do
        expect(telegram_bot).to receive(:send_message).with(
          chat_id: button_request.chat_id,
          text: I18n.t("errors.image_generating_error")
        )

        perform_job
      end
    end

    it "updates request status to FAILED" do
      expect { perform_job }
        .to change { button_request.reload.status }
        .from("PENDING")
        .to("FAILED")
    end
  end
end
