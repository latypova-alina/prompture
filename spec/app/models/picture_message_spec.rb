require "rails_helper"

describe PictureMessage, type: :model do
  describe "associations" do
    it { is_expected.to belong_to(:parent_request) }
    it { is_expected.to belong_to(:command_request) }
  end

  describe "delegations" do
    let(:command_request) { create(:command_image_to_video_request, chat_id: 123) }

    subject(:picture_message) do
      create(
        :picture_message,
        command_request:,
        parent_request: command_request
      )
    end

    it "delegates chat_id to command_request" do
      expect(picture_message.chat_id).to eq(123)
    end
  end
end
