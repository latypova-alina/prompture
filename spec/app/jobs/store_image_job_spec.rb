require "rails_helper"

describe StoreImage::Job do
  subject(:perform_job) { described_class.new.perform(record_type, record_id) }

  let!(:record) { create(:user_image_url_message) }
  let(:record_type) { record.class.name }
  let(:record_id) { record.id }
  let(:download_facade) { instance_double(StoreImage::Download::Facade, bytes: "image-bytes", filename: "image.jpg") }
  let(:upload_facade) { instance_double(StoreImage::Upload::Facade, stored_url: "https://internal.example/image.jpg") }

  before do
    allow(StoreImage::Download::Facade).to receive(:new).with(record).and_return(download_facade)
    allow(StoreImage::Upload::Facade).to receive(:new).with(bytes: "image-bytes",
                                                            filename: "image.jpg").and_return(upload_facade)
    allow(upload_facade).to receive(:upload_image)
    allow(StoreImage::StoredImageUpdater).to receive(:call)
    allow(StoreImage::SuccessNotifierJob).to receive(:perform_async)
    allow(StoreImage::ErrorNotifierJob).to receive(:perform_async)
  end

  describe "#perform" do
    it "builds source resolver and upload facade with expected inputs" do
      perform_job

      expect(StoreImage::Download::Facade).to have_received(:new).with(record)
      expect(StoreImage::Upload::Facade).to have_received(:new).with(bytes: "image-bytes", filename: "image.jpg")
    end

    it "uploads image using upload facade" do
      perform_job

      expect(upload_facade).to have_received(:upload_image)
    end

    it "updates stored image with uploaded url" do
      perform_job

      expect(StoreImage::StoredImageUpdater).to have_received(:call).with(
        record:,
        image_url: "https://internal.example/image.jpg"
      )
    end

    it "enqueues success notifier job" do
      perform_job

      expect(StoreImage::SuccessNotifierJob).to have_received(:perform_async).with(record_type, record_id)
    end

    context "when upload fails with image resolution error" do
      before do
        allow(upload_facade).to receive(:upload_image).and_raise(ImageResolutionError)
      end

      it "does not update stored image" do
        perform_job

        expect(StoreImage::StoredImageUpdater).not_to have_received(:call)
      end

      it "enqueues notifier with error class name" do
        perform_job

        expect(StoreImage::ErrorNotifierJob).to have_received(:perform_async).with(
          record_type,
          record_id,
          "ImageResolutionError"
        )
      end
    end
  end
end
