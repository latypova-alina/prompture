require "rails_helper"

describe StoreImage::StoredImageUpdater do
  subject(:call_updater) { described_class.call(record:, image_url:) }

  let(:image_url) { "https://internal.example/images/uuid-image.jpg" }

  context "when stored_image exists" do
    let(:record) { create(:user_image_url_message) }
    let!(:stored_image) { create(:stored_image, source_message: record, image_url: "https://old.example/image.jpg") }

    it "updates existing stored image url" do
      call_updater

      expect(stored_image.reload.image_url).to eq(image_url)
    end
  end

  context "when stored_image does not exist" do
    let(:record) { create(:user_picture_message) }

    it "builds and updates stored image url" do
      expect { call_updater }.to change(StoredImage, :count).by(1)
      expect(record.reload.stored_image.image_url).to eq(image_url)
    end
  end
end
