require "rails_helper"

describe RecordCreators::ButtonRequests::Videos::Kling3Standard do
  subject { described_class.new(parent_request, command_request).record }

  let(:user) { create(:user, :with_balance) }
  let(:command_request) do
    create(
      :command_two_frame_to_video_request,
      user:,
      start_image_url: "https://example.com/start.png",
      end_image_url: "https://example.com/end.png"
    )
  end
  let(:parent_request) do
    create(:user_picture_message, command_request:, parent_request: command_request)
  end

  it "creates a pending kling 3 standard video request" do
    record = subject

    expect(record).to have_attributes(
      processor: "kling_3_standard_image_to_video",
      status: "PENDING",
      image_url: "https://example.com/start.png",
      command_request:
    )
  end
end
