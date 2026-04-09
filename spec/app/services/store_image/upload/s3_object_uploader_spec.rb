require "rails_helper"

describe StoreImage::Upload::S3ObjectUploader do
  subject(:uploader) { described_class.new(bytes:, object_key:, content_type:) }

  let(:bytes) { "image-bytes" }
  let(:object_key) { "images/20260409/uuid-image.jpg" }
  let(:content_type) { "image/jpeg" }
  let(:s3_client) { instance_double(Aws::S3::Client) }

  before do
    allow(Aws::S3::Client).to receive(:new).with(region: ENV.fetch("AWS_REGION")).and_return(s3_client)
    allow(s3_client).to receive(:put_object)
  end

  describe "#upload" do
    it "uploads object to configured S3 bucket" do
      uploader.upload

      expect(s3_client).to have_received(:put_object).with(
        bucket: ENV.fetch("INTERNAL_BUCKET_NAME"),
        key: object_key,
        body: bytes,
        content_type:
      )
    end

    context "when bytes are blank" do
      let(:bytes) { "" }

      it "raises argument error" do
        expect { uploader.upload }.to raise_error(ArgumentError, "Image bytes are missing")
      end
    end
  end
end
