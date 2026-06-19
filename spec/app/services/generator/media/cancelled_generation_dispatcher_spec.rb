require "rails_helper"

describe Generator::Media::CancelledGenerationDispatcher do
  subject(:dispatch) { described_class.call(processor:, button_request_id:) }

  let(:button_request_id) { 123 }

  before do
    allow(Generator::Media::Image::CancellationNotifierJob).to receive(:perform_async)
    allow(Generator::Media::Video::CancellationNotifierJob).to receive(:perform_async)
  end

  context "when processor is an image processor" do
    let(:processor) { "flux_image" }

    it "enqueues image cancellation notifier job" do
      dispatch

      expect(Generator::Media::Image::CancellationNotifierJob)
        .to have_received(:perform_async)
        .with(button_request_id)
      expect(Generator::Media::Video::CancellationNotifierJob).not_to have_received(:perform_async)
    end
  end

  context "when processor is a video processor" do
    let(:processor) { "kling_2_1_pro_image_to_video" }

    it "enqueues video cancellation notifier job" do
      dispatch

      expect(Generator::Media::Video::CancellationNotifierJob)
        .to have_received(:perform_async)
        .with(button_request_id)
      expect(Generator::Media::Image::CancellationNotifierJob).not_to have_received(:perform_async)
    end
  end
end
