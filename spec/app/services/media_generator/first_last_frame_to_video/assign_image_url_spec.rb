require "rails_helper"

describe MediaGenerator::FirstLastFrameToVideo::AssignImageUrl do
  subject { described_class.call(image_record:) }

  let(:user) { create(:user, :with_balance) }
  let(:command_request) { create(:command_two_frame_to_video_request, user:) }
  let(:image_record) do
    create(
      :user_picture_message,
      command_request:,
      parent_request: command_request
    )
  end

  before do
    create(:stored_image, source_message: image_record, image_url: "https://example.com/frame.png")
  end

  it "assigns the first uploaded image to start_image_url" do
    subject

    expect(command_request.reload.start_image_url).to eq("https://example.com/frame.png")
    expect(command_request.end_image_url).to be_nil
  end

  context "when start frame is already set" do
    before do
      command_request.update!(start_image_url: "https://example.com/start.png")
    end

    it "assigns the next uploaded image to end_image_url" do
      subject

      expect(command_request.reload.end_image_url).to eq("https://example.com/frame.png")
    end
  end
end
