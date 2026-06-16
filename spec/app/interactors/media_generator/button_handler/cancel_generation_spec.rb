require "rails_helper"

describe MediaGenerator::ButtonHandler::CancelGeneration do
  subject(:result) do
    described_class.call(
      button_request:,
      callback_query_id:
    )
  end

  let(:callback_query_id) { "callback-123" }
  let(:generation_request) do
    create(:button_video_processing_request, interim_tg_message_id: 77_001)
  end
  let(:button_request) do
    "#{ButtonActions::CANCEL_GENERATION}:#{generation_request.id}:#{generation_request.class.name}"
  end
  let(:telegram_bot) { double }

  before do
    allow(Telegram).to receive(:bot).and_return(telegram_bot)
    allow(telegram_bot).to receive_messages(answer_callback_query: nil, send_message: nil)
  end

  context "when cancellation succeeds" do
    before do
      allow(Generator::Media::Interim::CancellationHandler).to receive(:call)
    end

    it "delegates to cancellation handler" do
      result

      expect(Generator::Media::Interim::CancellationHandler)
        .to have_received(:call)
        .with(generation_request:, callback_query_id:)
    end
  end

  context "when handler raises an error" do
    before do
      allow(Generator::Media::Interim::CancellationHandler)
        .to receive(:call)
        .and_raise(StandardError)
    end

    it "notifies user about failed cancellation" do
      result

      expect(telegram_bot).to have_received(:send_message).with(
        chat_id: generation_request.chat_id,
        text: I18n.t("errors.generation_cancel_failed")
      )
    end
  end
end
