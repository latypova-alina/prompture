require "rails_helper"

describe Generator::Media::Image::RetrieveTask::FluxImageRetriever do
  subject(:retrieved_media_url) do
    described_class.new(media_url:, button_request_id:, processor:).media_url
  end

  let(:media_url) { "https://fal.media/source.png" }
  let(:button_request_id) { 42 }
  let(:processor) { "flux_image" }
  let(:stored_media_retriever) { instance_double(Generator::Media::StoredMedia::Retriever) }

  before do
    allow(Generator::Media::StoredMedia::Retriever)
      .to receive(:new)
      .with(media_url:, button_request_id:, processor:)
      .and_return(stored_media_retriever)
  end

  context "when internal media URL is present" do
    it "returns internal media URL" do
      allow(stored_media_retriever).to receive(:internal_media_url).and_return("https://bucket/image.png")

      expect(retrieved_media_url).to eq("https://bucket/image.png")
    end
  end

  context "when internal media URL is nil" do
    it "falls back to source media URL" do
      allow(stored_media_retriever).to receive(:internal_media_url).and_return(nil)

      expect(retrieved_media_url).to eq(media_url)
    end
  end

  context "when storing raises an error" do
    it "falls back to source media URL" do
      allow(stored_media_retriever).to receive(:internal_media_url).and_raise(StandardError)

      expect(retrieved_media_url).to eq(media_url)
    end
  end
end
