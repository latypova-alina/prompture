require "rails_helper"

describe UserFileMessage, type: :model do
  describe "associations" do
    it { is_expected.to belong_to(:parent_request) }
    it { is_expected.to belong_to(:command_request) }
    it { is_expected.to have_one(:bot_telegram_message).dependent(:destroy) }
    it { is_expected.to have_one(:stored_image).dependent(:destroy) }
  end

  describe "delegations" do
    let(:command_request) { create(:command_image_to_video_request, chat_id: 123) }

    subject(:user_file_message) do
      UserFileMessage.create!(
        file_id: "BQACAgIAAxkBAAIHp...",
        size: 1.megabyte,
        tg_message_id: 123_456,
        command_request:,
        parent_request: command_request
      )
    end

    it "delegates chat_id to command_request" do
      expect(user_file_message.chat_id).to eq(123)
    end
  end

  describe "#resolved_image_url" do
    let(:user_file_message) do
      command_request = create(:command_image_to_video_request)
      UserFileMessage.create!(
        file_id: "BQACAgIAAxkBAAIHp...",
        size: 1.megabyte,
        tg_message_id: 123_456,
        command_request:,
        parent_request: command_request
      )
    end

    context "when stored_image exists" do
      let!(:stored_image) do
        create(:stored_image, source_message: user_file_message, image_url: "https://internal.example/image.png")
      end

      it "returns stored_image url" do
        expect(user_file_message.resolved_image_url).to eq("https://internal.example/image.png")
      end
    end

    context "when stored_image does not exist" do
      it "returns nil" do
        expect(user_file_message.resolved_image_url).to be_nil
      end
    end
  end
end
