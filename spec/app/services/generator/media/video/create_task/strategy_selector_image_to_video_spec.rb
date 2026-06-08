require "rails_helper"

describe Generator::Media::Video::CreateTask::StrategySelector do
  subject(:strategy) { described_class.new(request).strategy }

  let(:parent_prompt) { "ocean waves at sunset" }
  let(:command_request) { create(:command_image_to_video_request) }
  let(:picture_message) do
    create(:user_picture_message, command_request:, parent_request: command_request)
  end
  let(:parent_request) do
    create(:prompt_message, prompt: parent_prompt, command_request:, parent_request: picture_message)
  end
  let(:request) { create(:button_video_processing_request, parent_request:, command_request:) }

  it "passes prompt from image-to-video prompt message chain to Kling" do
    expect(strategy).to be_a(Generator::Media::Video::CreateTask::KlingPayloadStrategy)
    expect(strategy.prompt).to eq(parent_prompt)
  end
end
