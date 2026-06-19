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
    allow(Generator::Media::Interim::CancellationResultNotifier).to receive(:call)
  end

  it "marks the request as cancelled, deletes the interim message, and notifies the user" do
    call_handler

    expect(generation_request.reload.status).to eq("CANCELLED")
    expect(Generator::Media::Interim::MessageDeleter)
      .to have_received(:call)
      .with(request: generation_request)
    expect(Generator::Media::Interim::CancellationResultNotifier)
      .to have_received(:call)
      .with(
        generation_request:,
        callback_query_id:,
        success: true
      )
  end
end
