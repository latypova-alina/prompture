require "rails_helper"

describe CommandTwoFrameToVideoRequest, type: :model do
  describe "associations" do
    it do
      is_expected
        .to have_many(:button_video_processing_requests)
        .dependent(:destroy)
    end

    it { is_expected.to have_many(:prompt_messages).dependent(:destroy) }
    it { is_expected.to have_many(:user_picture_messages).dependent(:destroy) }
    it { is_expected.to have_many(:user_image_url_messages).dependent(:destroy) }
    it { is_expected.to have_many(:user_file_messages).dependent(:destroy) }
  end

  describe "#awaiting_end_image?" do
    it "returns true when only start image is set" do
      request = build(
        :command_two_frame_to_video_request,
        start_image_url: "https://example.com/start.png",
        end_image_url: nil
      )

      expect(request.awaiting_end_image?).to be(true)
    end

    it "returns false when both frames are set" do
      request = build(
        :command_two_frame_to_video_request,
        start_image_url: "https://example.com/start.png",
        end_image_url: "https://example.com/end.png"
      )

      expect(request.awaiting_end_image?).to be(false)
    end
  end

  describe "#frames_ready?" do
    it "returns true when both frames are set" do
      request = build(
        :command_two_frame_to_video_request,
        start_image_url: "https://example.com/start.png",
        end_image_url: "https://example.com/end.png"
      )

      expect(request.frames_ready?).to be(true)
    end

    it "returns false when end image is missing" do
      request = build(
        :command_two_frame_to_video_request,
        start_image_url: "https://example.com/start.png",
        end_image_url: nil
      )

      expect(request.frames_ready?).to be(false)
    end
  end

  describe "#latest_image_message" do
    let(:command_request) { create(:command_two_frame_to_video_request) }

    it "returns the most recent image message across supported types" do
      create(
        :user_picture_message,
        command_request:,
        parent_request: command_request,
        created_at: 2.minutes.ago
      )
      file_message = create(
        :user_file_message,
        command_request:,
        parent_request: command_request,
        created_at: 1.minute.ago
      )

      expect(command_request.latest_image_message).to eq(file_message)
    end
  end
end
