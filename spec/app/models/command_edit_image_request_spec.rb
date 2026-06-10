require "rails_helper"

describe CommandEditImageRequest, type: :model do
  describe "associations" do
    it do
      is_expected
        .to have_many(:button_image_processing_requests)
        .dependent(:destroy)
    end
  end

  describe "#prompt" do
    it "returns the stored prompt when present" do
      command_request = create(:command_edit_image_request, prompt: "Edit this image")

      expect(command_request.prompt).to eq("Edit this image")
    end

    it "falls back to the linked image prompt text" do
      image_prompt = create(:image_prompt, prompt: "Scene description")
      command_request = create(:command_edit_image_request, prompt: nil, image_prompt:)

      expect(command_request.prompt).to eq("Scene description")
    end
  end

  describe "#latest_image_message" do
    let(:command_request) { create(:command_edit_image_request) }

    it "returns the most recent image message" do
      older_message = create(
        :user_picture_message,
        command_request:,
        parent_request: command_request,
        created_at: 2.minutes.ago
      )
      newer_message = create(
        :user_image_url_message,
        command_request:,
        parent_request: command_request,
        created_at: 1.minute.ago
      )

      expect(command_request.latest_image_message).to eq(newer_message)
      expect(command_request.latest_image_message).not_to eq(older_message)
    end
  end
end
