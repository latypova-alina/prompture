require "rails_helper"

describe Admin::RecordFields do
  subject { described_class.call(record) }

  let(:record) do
    create(:command_two_frame_to_video_request, prompt: "a cat", start_image_url: "https://example.com/start.png")
  end

  it { is_expected.to include("prompt" => "a cat", "start_image_url" => "https://example.com/start.png") }
  it { is_expected.to include("chat_id", "created_at", "updated_at", "awaiting_video_prompt", "category") }
  it { is_expected.not_to include("id", "user_id") }

  context "when the record is a button request" do
    let(:record) { create(:button_image_processing_request) }

    it { is_expected.not_to include("parent_request_type", "parent_request_id", "command_request_type") }
  end
end
