require "rails_helper"

describe MediaGenerator::MessageHandler::ImageMessageHandler::CreatePictureMessage do
  subject(:result) do
    described_class.call(
      photo_file_id:,
      tg_message_id:,
      width:,
      height:,
      size_bytes:,
      command_request:
    )
  end

  let(:photo_file_id) { "AgACAgIAAxkBAAIB..." }
  let(:tg_message_id) { 123_456 }
  let(:width) { 960 }
  let(:height) { 1280 }
  let(:size_bytes) { 500.kilobytes }
  let(:command_request) { create(:command_image_to_video_request) }

  describe "#call" do
    it "creates a UserPictureMessage record" do
      expect { result }
        .to change(UserPictureMessage, :count).by(1)
    end

    it "assigns picture_message to the context" do
      expect(result.picture_message).to be_a(UserPictureMessage)
    end

    it "sets correct attributes on UserPictureMessage" do
      picture_message = result.picture_message

      expect(picture_message.picture_id).to eq(photo_file_id)
      expect(picture_message.tg_message_id).to eq(tg_message_id)
      expect(picture_message.size).to eq(size_bytes)
      expect(picture_message.width).to eq(width)
      expect(picture_message.height).to eq(height)
      expect(picture_message.parent_request).to eq(command_request)
      expect(picture_message.command_request).to eq(command_request)
    end

    context "when photo_file_id is nil" do
      let(:photo_file_id) { nil }

      it "does not create a UserPictureMessage record" do
        expect { result }
          .not_to change(UserPictureMessage, :count)
      end

      it "assigns nil picture_message to the context" do
        expect(result.picture_message).to be_nil
      end
    end
  end
end
