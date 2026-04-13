require "rails_helper"

describe Generator::Media::StoredMedia::Uploader do
  subject(:uploader) { described_class.new(media_url:, record:) }

  let(:media_url) { "https://ai-statics.freepik.com/content/generated.png?token=abc" }
  let!(:record) { create(:button_image_processing_request) }
  let(:uploaded_url) { "https://internal.example/images/generated.png" }
  let(:upload_facade) { instance_double(StoreImage::Upload::Facade, stored_url: uploaded_url) }

  before do
    allow(StoreImage::Download::UrlImageDownloader).to receive(:call).with(media_url).and_return("image-bytes")
    allow(StoreImage::Upload::Facade).to receive(:new).and_return(upload_facade)
    allow(upload_facade).to receive(:upload_image)
    allow(StoreImage::StoredImageUpdater).to receive(:call).and_call_original
  end

  describe "#call" do
    it "uploads and stores internal url" do
      expect { uploader.call }.to change(StoredImage, :count).by(1)
      expect(record.reload.stored_image.image_url).to eq(uploaded_url)
    end

    it "builds upload facade with downloaded bytes and resolved filename" do
      uploader.call

      expect(StoreImage::Upload::Facade).to have_received(:new).with(
        bytes: "image-bytes",
        filename: "generated.png"
      )
    end
  end

  describe "#stored_url" do
    it "returns upload facade stored url" do
      expect(uploader.stored_url).to eq(uploaded_url)
    end
  end
end
