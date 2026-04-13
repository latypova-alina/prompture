require "rails_helper"

describe Generator::Media::StoredMedia::Retriever do
  subject(:service) { described_class.new(media_url:, button_request_id:, processor:) }

  let(:media_url) { "https://ai-statics.freepik.com/generated.png" }
  let!(:button_request) { create(:button_image_processing_request) }
  let(:button_request_id) { button_request.id }
  let(:processor) { "mystic_image" }
  let(:uploaded_url) { "https://internal.example/images/generated.png" }
  let(:uploader) { instance_double(Generator::Media::StoredMedia::Uploader, stored_url: uploaded_url) }

  before do
    allow(Generator::Media::StoredMedia::Uploader)
      .to receive(:new)
      .with(media_url:, record: button_request)
      .and_return(uploader)
  end

  describe "#internal_media_url" do
    context "when processor is image" do
      it "uses uploader and returns internal media url" do
        allow(uploader).to receive(:call)

        expect(service.internal_media_url).to eq(uploaded_url)
        expect(uploader).to have_received(:call)
      end
    end

    context "when processor is not image" do
      let(:processor) { Generator::Processors::PROMPT_EXTENSION }

      it "returns original media_url without creating stored image" do
        expect(service.internal_media_url).to eq(media_url)
        expect(Generator::Media::StoredMedia::Uploader).not_to have_received(:new)
      end
    end
  end
end
