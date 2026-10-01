require "rails_helper"

describe Admin::CommandInputs do
  subject { described_class.call(command_request) }

  let(:command_request) { create(:command_image_to_video_request) }
  let(:other_command) { create(:command_image_to_video_request) }

  let!(:picture) do
    create(:user_picture_message, command_request:, parent_request: command_request, created_at: 3.days.ago)
  end
  let!(:file) do
    create(:user_file_message, command_request:, parent_request: command_request, created_at: 2.days.ago)
  end
  let!(:prompt) do
    create(:prompt_message, command_request:, parent_request: command_request, created_at: 1.day.ago)
  end
  let!(:image_url) do
    create(:user_image_url_message, command_request:, parent_request: command_request, created_at: 1.hour.ago)
  end

  before { create(:prompt_message, command_request: other_command, parent_request: other_command) }

  it { is_expected.to eq([picture, file, prompt, image_url]) }
end
