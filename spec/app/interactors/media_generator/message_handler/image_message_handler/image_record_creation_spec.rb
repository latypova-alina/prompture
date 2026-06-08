require "rails_helper"

describe "image message record creation" do
  let(:command_request) { create(:command_image_to_video_request) }

  context "when user sends a photo" do
    it "creates only UserPictureMessage" do
      expect do
        MediaGenerator::MessageHandler::ImageMessageHandler::CreatePictureMessage.call(
          photo_file_id: "photo_123",
          width: 1280,
          height: 720,
          size_bytes: 5000,
          command_request:,
          tg_message_id: 42
        )
        MediaGenerator::MessageHandler::ImageMessageHandler::CreateFileMessage.call(
          file_id: nil,
          size_bytes: 5000,
          command_request:,
          tg_message_id: 42
        )
      end.to change(UserPictureMessage, :count).by(1)
                                               .and change(UserFileMessage, :count).by(0)
    end
  end

  context "when user sends an image file" do
    it "creates only UserFileMessage" do
      expect do
        MediaGenerator::MessageHandler::ImageMessageHandler::CreatePictureMessage.call(
          photo_file_id: nil,
          width: nil,
          height: nil,
          size_bytes: 1.megabyte,
          command_request:,
          tg_message_id: 42
        )
        MediaGenerator::MessageHandler::ImageMessageHandler::CreateFileMessage.call(
          file_id: "file_123",
          size_bytes: 1.megabyte,
          command_request:,
          tg_message_id: 42
        )
      end.to change(UserFileMessage, :count).by(1)
                                            .and change(UserPictureMessage, :count).by(0)
    end
  end
end
