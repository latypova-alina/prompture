require "rails_helper"

describe Generator::Media::Video::EnqueueVideoTask do
  subject(:call_service) { described_class.call(request) }

  let(:request) { create(:button_video_processing_request) }

  before do
    allow(Generator::Media::Interim::MessageSender).to receive(:call)
    allow(Generator::Media::Video::TaskCreatorJob).to receive(:perform_in)
  end

  it "sends interim message and enqueues delayed video generator job" do
    call_service

    expect(Generator::Media::Interim::MessageSender)
      .to have_received(:call)
      .with(request:)
    expect(Generator::Media::Video::TaskCreatorJob)
      .to have_received(:perform_in)
      .with(described_class::TASK_CREATION_DELAY, request.id)
  end
end
