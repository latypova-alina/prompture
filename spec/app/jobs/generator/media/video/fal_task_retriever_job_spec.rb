require "rails_helper"

describe Generator::Media::Video::FalTaskRetrieverJob do
  subject(:perform_job) do
    described_class.new.perform(generated_media_url, button_request_id, processor)
  end

  let(:generated_media_url) { "https://fal.media/source.mp4" }
  let(:button_request_id) { 42 }
  let(:processor) { "kling_2_1_pro_image_to_video" }

  let(:stored_media) { instance_double(Generator::Media::StoredMedia::Retriever, internal_media_url: media_url) }
  let(:media_url) { "http://example.com/video.mp4" }

  before do
    allow(Generator::Media::StoredMedia::Retriever)
      .to receive(:new)
      .with(media_url: generated_media_url, button_request_id:, processor:)
      .and_return(stored_media)
  end

  describe "#perform" do
    context "when storing succeeds" do
      before do
        allow(Generator::Media::Video::SuccessNotifierJob).to receive(:perform_async)
      end

      it "calls SuccessNotifierJob with stored media url" do
        expect(Generator::Media::Video::SuccessNotifierJob)
          .to receive(:perform_async)
          .with(media_url, button_request_id)

        perform_job
      end
    end

    context "when storing fails" do
      before do
        allow(stored_media).to receive(:internal_media_url).and_raise(StandardError)
        allow(Generator::Media::Video::SuccessNotifierJob).to receive(:perform_async)
      end

      it "falls back to generated media url and still notifies success" do
        expect(Generator::Media::Video::SuccessNotifierJob)
          .to receive(:perform_async)
          .with(generated_media_url, button_request_id)

        perform_job
      end
    end
  end
end
