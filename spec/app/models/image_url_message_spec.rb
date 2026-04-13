require "rails_helper"

describe ImageUrlMessage, type: :model do
  describe "associations" do
    it { is_expected.to belong_to(:parent_request) }
    it { is_expected.to belong_to(:command_request) }
    it { is_expected.to have_one(:bot_telegram_message).dependent(:destroy) }
    it { is_expected.to have_one(:stored_image).dependent(:destroy) }
  end

  describe "delegations" do
    let(:command_request) { create(:command_prompt_to_video_request, chat_id: 123) }

    subject(:image_url_message) do
      create(
        :image_url_message,
        command_request:,
        parent_request: command_request
      )
    end

    it "delegates chat_id to command_request" do
      expect(image_url_message.chat_id).to eq(123)
    end
  end

  describe "#resolved_image_url" do
    let(:image_url_message) { create(:image_url_message, image_url: "https://external.example/image.png") }

    context "when stored_image exists" do
      let!(:stored_image) do
        create(:stored_image, source_message: image_url_message, image_url: "https://internal.example/image.png")
      end

      it "returns stored_image url" do
        expect(image_url_message.resolved_image_url).to eq("https://internal.example/image.png")
      end
    end

    context "when stored_image does not exist" do
      it "returns original image_url" do
        expect(image_url_message.resolved_image_url).to eq("https://external.example/image.png")
      end
    end
  end
end
