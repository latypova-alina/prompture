require "rails_helper"

describe StoreImage::Upload::Facade do
  subject(:facade) { described_class.new(bytes:, filename:) }

  let(:bytes) { "image-bytes" }
  let(:filename) { "image.jpg" }
  let(:object_key) { "images/20260409/uuid-image.jpg" }
  let(:content_type) { "image/jpeg" }
  let(:stored_url) { "https://internal.example/#{object_key}" }
  let(:object_uploader) { instance_double(StoreImage::Upload::S3ObjectUploader, upload: true) }
  let(:url_builder) { instance_double(StoreImage::Upload::StoredUrlBuilder, stored_url:) }

  before do
    allow(StoreImage::Upload::ObjectKeyBuilder).to receive(:new).with(filename:).and_return(
      instance_double(StoreImage::Upload::ObjectKeyBuilder, object_key:)
    )
    allow(StoreImage::Upload::ContentTypeResolver).to receive(:new).with(filename:).and_return(
      instance_double(StoreImage::Upload::ContentTypeResolver, content_type:)
    )
    allow(StoreImage::Upload::S3ObjectUploader)
      .to receive(:new)
      .with(bytes:, object_key:, content_type:)
      .and_return(object_uploader)
    allow(StoreImage::Upload::StoredUrlBuilder).to receive(:new).with(object_key:).and_return(url_builder)
  end

  describe "#upload_image" do
    it "uploads object through S3ObjectUploader" do
      facade.upload_image

      expect(object_uploader).to have_received(:upload)
    end
  end

  describe "#stored_url" do
    it "returns url from StoredUrlBuilder" do
      expect(facade.stored_url).to eq(stored_url)
    end
  end
end
