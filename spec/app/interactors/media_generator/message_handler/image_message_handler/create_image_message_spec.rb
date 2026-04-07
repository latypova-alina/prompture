require "rails_helper"

describe MediaGenerator::MessageHandler::ImageMessageHandler::CreateImageMessage do
  subject(:result) { described_class.call(image_url:, command_request:) }

  let(:image_url) { "https://example.com/image.jpg" }
  let(:command_request) { create(:command_image_to_video_request) }

  describe "#call" do
    it "creates an ImageMessage record" do
      expect { result }
        .to change(ImageMessage, :count).by(1)
    end

    it "assigns image_message to the context" do
      expect(result.image_message).to be_a(ImageMessage)
    end

    it "sets correct attributes on ImageMessage" do
      image_message = result.image_message

      expect(image_message.image_url).to eq(image_url)
      expect(image_message.parent_request).to eq(command_request)
      expect(image_message.command_request).to eq(command_request)
    end
  end
end
