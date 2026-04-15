require "rails_helper"

describe MediaGenerator::MessageHandler::ImageMessageHandler::CreateFileMessage do
  subject(:result) do
    described_class.call(
      picture_id:,
      size_bytes:,
      command_request:,
      tg_message_id:
    )
  end

  let(:picture_id) { "BQACAgIAAxkBAAIHp..." }
  let(:size_bytes) { 1.megabyte }
  let(:command_request) { create(:command_image_to_video_request) }
  let(:tg_message_id) { 123_456 }

  describe "#call" do
    it "creates a UserFileMessage record" do
      expect { result }
        .to change(UserFileMessage, :count).by(1)
    end

    it "assigns file_message to the context" do
      expect(result.file_message).to be_a(UserFileMessage)
    end

    it "sets correct attributes on UserFileMessage" do
      file_message = result.file_message

      expect(file_message.file_id).to eq(picture_id)
      expect(file_message.size).to eq(size_bytes)
      expect(file_message.tg_message_id).to eq(tg_message_id)
      expect(file_message.parent_request).to eq(command_request)
      expect(file_message.command_request).to eq(command_request)
    end

    context "when picture_id is nil" do
      let(:picture_id) { nil }

      it "does not create a UserFileMessage record" do
        expect { result }
          .not_to change(UserFileMessage, :count)
      end

      it "assigns nil file_message to the context" do
        expect(result.file_message).to be_nil
      end
    end
  end
end
