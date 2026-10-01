require "rails_helper"

describe Admin::CommandButtonRequestsLoader do
  subject { described_class.call(command_requests) }

  let(:user) { create(:user, :with_balance) }
  let(:image_command) { create(:command_prompt_to_image_request, user:) }
  let(:video_command) { create(:command_prompt_to_video_request, user:) }
  let(:off_page_command) { create(:command_prompt_to_image_request, user:) }
  let(:command_requests) { [image_command, video_command] }

  let!(:image_request) do
    create(:button_image_processing_request, :completed, command_request: image_command, created_at: 2.days.ago)
  end
  let!(:extend_prompt_request) do
    create(:button_extend_prompt_request, command_request: image_command, created_at: 3.days.ago)
  end
  let!(:video_request) { create(:button_video_processing_request, command_request: video_command) }

  before { create(:button_image_processing_request, :completed, command_request: off_page_command) }

  it do
    is_expected.to eq(
      ["CommandPromptToImageRequest", image_command.id] => [extend_prompt_request, image_request],
      ["CommandPromptToVideoRequest", video_command.id] => [video_request]
    )
  end

  context "when there are no command requests" do
    let(:command_requests) { [] }

    it { is_expected.to eq({}) }
  end
end
