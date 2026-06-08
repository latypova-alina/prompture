require "rails_helper"

describe OriginImageUrl do
  describe ".resolve" do
    let(:command_request) { create(:command_image_to_video_request) }
    let(:picture_message) do
      create(:user_picture_message, command_request:, parent_request: command_request)
    end

    before do
      create(:stored_image, source_message: picture_message, image_url: "https://example.com/image.png")
    end

    it "returns direct image url from image messages" do
      expect(described_class.resolve(picture_message)).to eq("https://example.com/image.png")
    end

    it "returns image url through prompt message parent chain" do
      prompt_message = create(
        :prompt_message,
        prompt: "ocean waves",
        command_request:,
        parent_request: picture_message
      )

      expect(described_class.resolve(prompt_message)).to eq("https://example.com/image.png")
    end
  end
end
