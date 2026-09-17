require "rails_helper"

describe Generator::Media::Audio::ErrorNotifierJob do
  subject(:perform_job) { described_class.new.perform(button_request.id) }

  let(:button_request) { create(:button_audio_processing_request, status: "PENDING") }

  let(:telegram_bot) { double }

  before do
    allow(Telegram).to receive(:bot).and_return(telegram_bot)
    allow(telegram_bot).to receive(:send_message)
    allow(Sentry).to receive(:capture_message)
  end

  describe "#perform" do
    context "when parent request has bot telegram message" do
      before do
        create(:bot_telegram_message, request: button_request.parent_request, tg_message_id: 123_456)
      end

      it "sends telegram message with reply_to_message_id" do
        expect(telegram_bot).to receive(:send_message).with(
          chat_id: button_request.chat_id,
          text: I18n.t("errors.audio_generating_error"),
          reply_to_message_id: 123_456
        )

        perform_job
      end
    end

    context "when parent request has no bot telegram message" do
      it "sends telegram message without reply_to_message_id" do
        expect(telegram_bot).to receive(:send_message).with(
          chat_id: button_request.chat_id,
          text: I18n.t("errors.audio_generating_error")
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

    it "does not report to Sentry" do
      perform_job

      expect(Sentry).not_to have_received(:capture_message)
    end

    context "when fal.ai reports an unrecognized failure reason" do
      let(:flagged_message) { "Voice not found: b0SLZi0fffAtGahM2kvn" }

      subject(:perform_job) { described_class.new.perform(button_request.id, nil, flagged_message) }

      it "reports the flagged message to Sentry" do
        perform_job

        expect(Sentry)
          .to have_received(:capture_message)
          .with(flagged_message, level: :error)
      end
    end

    context "when the content was flagged by moderation" do
      subject(:perform_job) { described_class.new.perform(button_request.id, "content_flagged", "explicit content") }

      it "reports the flagged message to Sentry at info level" do
        perform_job

        expect(Sentry)
          .to have_received(:capture_message)
          .with("explicit content", level: :info)
      end
    end
  end
end
