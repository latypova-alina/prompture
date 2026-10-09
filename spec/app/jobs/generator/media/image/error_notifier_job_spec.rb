require "rails_helper"

describe Generator::Media::Image::ErrorNotifierJob do
  subject(:perform_job) { described_class.new.perform(button_request.id) }

  let(:button_request) { create(:button_image_processing_request, status: "PENDING") }

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

    context "when the failure was already recorded at submit time" do
      before { button_request.update!(failure_reason: "response_error", failure_message: '{"detail":"bad"}') }

      it "keeps the recorded details" do
        perform_job

        expect(button_request.reload)
          .to have_attributes(failure_reason: "response_error", failure_message: '{"detail":"bad"}')
      end
    end

    it "does not report to Sentry" do
      perform_job

      expect(Sentry).not_to have_received(:capture_message)
    end

    context "when fal.ai reports an unrecognized failure reason" do
      subject(:perform_job) { described_class.new.perform(button_request.id, nil, "Voice not found: xyz") }

      it "reports the flagged message to Sentry" do
        perform_job

        expect(Sentry)
          .to have_received(:capture_message)
          .with("Voice not found: xyz", level: :error)
      end
    end

    context "when the content was flagged by moderation" do
      subject(:perform_job) { described_class.new.perform(button_request.id, "content_flagged", "explicit content") }

      it "records fal's reason and message on the request" do
        perform_job

        expect(button_request.reload).to have_attributes(
          status: "FAILED", failure_reason: "content_flagged", failure_message: "explicit content"
        )
      end

      it "reports the flagged message to Sentry at info level" do
        perform_job

        expect(Sentry)
          .to have_received(:capture_message)
          .with("explicit content", level: :info)
      end
    end
  end
end
