require "rails_helper"

describe MediaGenerator::MessageHandler::ImageMessageHandler::CreateImageUrlMessage do
  subject(:result) { described_class.call(image_url:, command_request:, tg_message_id:) }

  let(:image_url) { "https://example.com/image.jpg" }
  let(:command_request) { create(:command_image_to_video_request) }
  let(:tg_message_id) { 123_456 }

  describe "#call" do
    it "creates an ImageUrlMessage record" do
      expect { result }
        .to change(ImageUrlMessage, :count).by(1)
    end

    it "assigns image_url_message to the context" do
      expect(result.image_url_message).to be_a(ImageUrlMessage)
    end

    it "sets correct attributes on ImageUrlMessage" do
      image_url_message = result.image_url_message

      expect(image_url_message.image_url).to eq(image_url)
      expect(image_url_message.tg_message_id).to eq(tg_message_id)
      expect(image_url_message.parent_request).to eq(command_request)
      expect(image_url_message.command_request).to eq(command_request)
    end

    context "when image_url is nil" do
      let(:image_url) { nil }

      it "does not create an ImageUrlMessage record" do
        expect { result }
          .not_to change(ImageUrlMessage, :count)
      end

      it "assigns nil image_url_message to the context" do
        expect(result.image_url_message).to be_nil
      end
    end
  end
end
