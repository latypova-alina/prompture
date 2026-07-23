require "rails_helper"

describe MediaGenerator::ButtonHandler::ForBloomy::ShortComplexScript::CreateAndEnqueue::ButtonRequestCreator do
  subject(:result) { described_class.new(two_frame_request:).button_request_record }

  let(:user) { create(:user, :with_balance) }
  let(:two_frame_request) do
    create(
      :command_two_frame_to_video_request,
      user:,
      start_image_url: "https://example.com/start.png",
      end_image_url: "https://example.com/end.png"
    )
  end

  it "creates a kling 3 standard button request" do
    expect { result }.to change(ButtonVideoProcessingRequest, :count).by(1)
    expect(result.processor).to eq("kling_3_standard_image_to_video")
    expect(result.command_request).to eq(two_frame_request)
  end
end
