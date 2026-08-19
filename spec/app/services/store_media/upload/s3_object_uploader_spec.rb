require "rails_helper"

describe StoreMedia::Upload::S3ObjectUploader do
  subject(:uploader) { described_class.new(bytes:, object_key:, content_type:) }

  let(:bytes) { "media-bytes" }
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
        expect { uploader.upload }.to raise_error(ArgumentError, "Media bytes are missing")
      end
    end

    context "when the upload fails transiently and then succeeds" do
      before do
        allow(uploader).to receive(:sleep)

        attempts = 0
        allow(s3_client).to receive(:put_object) do
          attempts += 1
          raise StandardError, "boom" if attempts == 1
        end
      end

      it "retries and eventually uploads successfully" do
        uploader.upload

        expect(s3_client).to have_received(:put_object).twice
      end
    end

    context "when the upload keeps failing" do
      before do
        allow(uploader).to receive(:sleep)
        allow(s3_client).to receive(:put_object).and_raise(StandardError, "boom")
      end

      it "gives up after 3 attempts and raises" do
        expect { uploader.upload }.to raise_error(StandardError, "boom")

        expect(s3_client).to have_received(:put_object).exactly(3).times
      end
    end
  end
end
