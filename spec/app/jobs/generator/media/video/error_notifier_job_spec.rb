require "rails_helper"

describe Generator::Media::Video::ErrorNotifierJob do
  subject(:perform_job) { described_class.new.perform(button_request.id) }

  let(:button_request) { create(:button_video_processing_request, status: "PENDING") }

  let(:telegram_bot) { double }

  before do
    allow(Telegram).to receive(:bot).and_return(telegram_bot)
    allow(telegram_bot).to receive(:send_message)
  end

  describe "#perform" do
    context "when parent request has bot telegram message" do
      before do
        create(:bot_telegram_message, request: button_request.parent_request, tg_message_id: 123_456)
      end

      it "sends telegram message with reply_to_message_id" do
        expect(telegram_bot).to receive(:send_message).with(
          chat_id: button_request.chat_id,
          text: I18n.t("errors.video_generating_error"),
          reply_to_message_id: 123_456
        )

        perform_job
      end
    end

    context "when origin message is on an ancestor request" do
      let(:command_request) { create(:command_edit_image_request) }
      let(:image_request) do
        create(
          :button_image_processing_request,
          :completed,
          command_request:,
          parent_request: command_request
        )
      end
      let(:prompt_message) do
        create(
          :prompt_message,
          command_request:,
          parent_request: image_request
        )
      end
      let(:button_request) do
        create(
          :button_video_processing_request,
          status: "PENDING",
          command_request: create(:command_prompt_to_video_request, user: command_request.user),
          parent_request: prompt_message
        )
      end

      before do
        create(:bot_telegram_message, request: image_request, tg_message_id: 6280)
      end

      it "sends telegram message with reply_to_message_id" do
        expect(telegram_bot).to receive(:send_message).with(
          chat_id: button_request.chat_id,
          text: I18n.t("errors.video_generating_error"),
          reply_to_message_id: 6280
        )

        perform_job
      end
    end

    context "when parent request has no bot telegram message" do
      it "sends telegram message without reply_to_message_id" do
        expect(telegram_bot).to receive(:send_message).with(
          chat_id: button_request.chat_id,
          text: I18n.t("errors.video_generating_error")
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

    context "when custom error reason is provided" do
      subject(:perform_job) { described_class.new.perform(button_request.id, "daily_limit_exceeded") }

      it "uses custom translated error text" do
        expect(telegram_bot).to receive(:send_message).with(
          chat_id: button_request.chat_id,
          text: I18n.t("errors.daily_limit_exceeded")
        )

        perform_job
      end
    end
  end
end
