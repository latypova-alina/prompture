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

  context "when record is a cartoon script generation with a matching image prompt" do
    let(:image_prompt) { create(:image_prompt, prompt: "Bloomy waves at the camera.") }
    let(:command_request) do
      create(
        :command_edit_image_request,
        category: ContentCategory::CARTOON_SCRIPT,
        prompt: image_prompt.prompt
      )
    end
    let(:record) { create(:button_image_processing_request, command_request:) }

    before { image_prompt }

    it "attaches the stored image to the image prompt" do
      call_updater

      expect(record.reload.stored_image).to have_attributes(
        image_url:,
        image_prompt:
      )
      expect(image_prompt.stored_images).to contain_exactly(record.stored_image)
    end
  end
end
