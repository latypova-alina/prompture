require "rails_helper"

describe StoreImage::ImagePromptResolver do
  subject(:resolved_image_prompt) { described_class.call(record:) }

  context "when record is a cartoon script edit image request with a matching image prompt" do
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

    it "returns the image prompt matched by prompt text" do
      expect(resolved_image_prompt).to eq(image_prompt)
    end
  end

  context "when record is a button image processing request without a matching image prompt" do
    let(:command_request) do
      create(
        :command_edit_image_request,
        category: ContentCategory::CARTOON_SCRIPT,
        prompt: "Unknown prompt"
      )
    end
    let(:record) { create(:button_image_processing_request, command_request:) }

    it "returns nil" do
      expect(resolved_image_prompt).to be_nil
    end
  end

  context "when record is a non-cartoon edit image request" do
    let(:record) { create(:button_image_processing_request) }

    it "returns nil" do
      expect(resolved_image_prompt).to be_nil
    end
  end

  context "when record is not applicable" do
    let(:record) { create(:user_image_url_message) }

    it "returns nil" do
      expect(resolved_image_prompt).to be_nil
    end
  end
end
