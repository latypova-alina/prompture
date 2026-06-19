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
  let(:canceller) do
    instance_double(Generator::Media::FalRequestCanceller, cancel_request: nil, success?: success)
  end

  before do
    allow(Generator::Media::FalRequestCanceller).to receive(:new).and_return(canceller)
    allow(Generator::Media::Interim::CancellationResultNotifier).to receive(:call)
  end

  context "when cancellation succeeds" do
    let(:success) { true }

    it "requests cancellation and notifies about the result" do
      call_handler

      expect(canceller).to have_received(:cancel_request)
      expect(Generator::Media::Interim::CancellationResultNotifier)
        .to have_received(:call)
        .with(
          generation_request:,
          callback_query_id:,
          success: true
        )
    end
  end

  context "when cancellation fails" do
    let(:success) { false }

    it "requests cancellation and notifies about the result" do
      call_handler

      expect(canceller).to have_received(:cancel_request)
      expect(Generator::Media::Interim::CancellationResultNotifier)
        .to have_received(:call)
        .with(
          generation_request:,
          callback_query_id:,
          success: false
        )
    end
  end
end
