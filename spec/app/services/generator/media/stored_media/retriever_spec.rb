require "rails_helper"

describe Generator::Media::StoredMedia::Retriever do
  subject(:retriever) { described_class.new(media_url:, button_request_id:, processor:) }

  let(:media_url) { "https://fal.media/source.mp4" }
  let(:button_request_id) { 42 }
  let(:processor) { "kling_2_1_pro_image_to_video" }

  let(:stored_media_type) do
    instance_double(Generator::Media::StoredMedia::StoredMediaType, needs_to_be_stored?: needs_to_be_stored, uploader:)
  end
  let(:needs_to_be_stored) { true }
  let(:uploader) do
    instance_double(Generator::Media::StoredMedia::VideoUploader, call: nil, stored_url: "https://media.example.com/video.mp4")
  end

  before do
    allow(Generator::Media::StoredMedia::StoredMediaType)
      .to receive(:new)
      .with(processor:, media_url:, button_request_id:)
      .and_return(stored_media_type)
  end

  describe "#internal_media_url" do
    context "when the media does not need to be stored" do
      let(:needs_to_be_stored) { false }

      it "returns the original media url" do
        expect(retriever.internal_media_url).to eq(media_url)
      end
    end

    context "when storing succeeds" do
      it "uploads and returns the stored url" do
        expect(retriever.internal_media_url).to eq("https://media.example.com/video.mp4")
      end
    end

    context "when storing fails" do
      let(:error) { StandardError.new("upload boom") }

      before do
        allow(uploader).to receive(:call).and_raise(error)
        allow(Generator::Media::StoredMedia::UploadFailureReporter).to receive(:call)
      end

      it "falls back to the original media url" do
        expect(retriever.internal_media_url).to eq(media_url)
      end

      it "reports the failure" do
        retriever.internal_media_url

        expect(Generator::Media::StoredMedia::UploadFailureReporter)
          .to have_received(:call)
          .with(error:, button_request_id:, processor:, media_url:)
      end
    end
  end
end
