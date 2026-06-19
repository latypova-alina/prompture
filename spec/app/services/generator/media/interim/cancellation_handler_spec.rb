require "rails_helper"

describe Generator::Media::Interim::CancellationHandler do
  subject(:call_handler) do
    described_class.call(
      generation_request:,
      callback_query_id:
    )
  end

  let(:callback_query_id) { "callback-123" }
  let(:generation_request) do
    create(:button_video_processing_request, interim_tg_message_id: 77_001)
  end

  before do
    allow(Generator::Media::Interim::MessageDeleter).to receive(:call)
    allow(Generator::Media::Interim::Notifier::Success).to receive(:call)
    allow(Generator::Media::Interim::Notifier::Outdated).to receive(:call)
  end

  context "when generation has not been sent to fal yet" do
    it "marks the request as cancelled, deletes the interim message, and notifies the user" do
      call_handler

      expect(generation_request.reload.status).to eq("CANCELLED")
      expect(Generator::Media::Interim::MessageDeleter)
        .to have_received(:call)
        .with(request: generation_request)
      expect(Generator::Media::Interim::Notifier::Success)
        .to have_received(:call)
        .with(generation_request:, callback_query_id:)
      expect(Generator::Media::Interim::Notifier::Outdated).not_to have_received(:call)
    end
  end

  context "when generation has already been sent to fal" do
    let(:generation_request) do
      create(
        :button_video_processing_request,
        interim_tg_message_id: 77_001,
        fal_request_id: "req-123"
      )
    end

    it "does not cancel the request or delete the interim message" do
      call_handler

      expect(generation_request.reload.status).to eq("PENDING")
      expect(Generator::Media::Interim::MessageDeleter).not_to have_received(:call)
      expect(Generator::Media::Interim::Notifier::Outdated)
        .to have_received(:call)
        .with(generation_request:, callback_query_id:)
      expect(Generator::Media::Interim::Notifier::Success).not_to have_received(:call)
    end
  end
end
