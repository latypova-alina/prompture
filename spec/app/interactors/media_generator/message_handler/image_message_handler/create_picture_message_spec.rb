require "rails_helper"

describe MediaGenerator::MessageHandler::ImageMessageHandler::CreatePictureMessage do
  subject(:result) do
    described_class.call(
      picture_id:,
      width:,
      height:,
      size_bytes:,
      command_request:
    )
  end

  let(:picture_id) { "AgACAgIAAxkBAAIB..." }
  let(:width) { 960 }
  let(:height) { 1280 }
  let(:size_bytes) { 500.kilobytes }
  let(:command_request) { create(:command_image_to_video_request) }

  describe "#call" do
    it "creates a PictureMessage record" do
      expect { result }
        .to change(PictureMessage, :count).by(1)
    end

    it "assigns picture_message to the context" do
      expect(result.picture_message).to be_a(PictureMessage)
    end

    it "sets correct attributes on PictureMessage" do
      picture_message = result.picture_message

      expect(picture_message.picture_id).to eq(picture_id)
      expect(picture_message.size).to eq(size_bytes)
      expect(picture_message.width).to eq(width)
      expect(picture_message.height).to eq(height)
      expect(picture_message.parent_request).to eq(command_request)
      expect(picture_message.command_request).to eq(command_request)
    end

    context "when picture_id is nil" do
      let(:picture_id) { nil }

      it "does not create a PictureMessage record" do
        expect { result }
          .not_to change(PictureMessage, :count)
      end

      it "assigns nil picture_message to the context" do
        expect(result.picture_message).to be_nil
      end
    end
  end
end
