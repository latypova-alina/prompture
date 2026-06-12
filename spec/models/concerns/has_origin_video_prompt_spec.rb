require "rails_helper"

RSpec.describe HasOriginVideoPrompt do
  subject(:origin_video_prompt) { request.origin_video_prompt }

  let(:command_request) do
    create(:command_prompt_to_video_request, category: ContentCategory::CARTOON_SCRIPT)
  end
  let(:video_prompt) { create(:video_prompt) }
  let(:prompt_message) { create(:prompt_message, video_prompt:, command_request:) }
  let(:request) do
    create(
      :button_video_processing_request,
      command_request:,
      parent_request: prompt_message
    )
  end

  it "returns the video prompt from an ancestor prompt message" do
    expect(origin_video_prompt).to eq(video_prompt)
  end

  context "when parent is a regenerated video request" do
    let(:request) do
      create(
        :button_video_processing_request,
        command_request:,
        parent_request: create(
          :button_video_processing_request,
          command_request:,
          parent_request: prompt_message
        )
      )
    end

    it "returns the video prompt from the ancestor prompt message" do
      expect(origin_video_prompt).to eq(video_prompt)
    end
  end

  context "when no ancestor prompt message has a video prompt" do
    let(:prompt_message) { create(:prompt_message, command_request:) }

    it "returns nil" do
      expect(origin_video_prompt).to be_nil
    end
  end
end
