require "rails_helper"

describe MediaGenerator::ButtonHandler::ValidateCartoonVideoScriptRequest do
  subject(:result) { described_class.call(context) }

  let(:command_request) do
    create(:command_prompt_to_video_request, category: ContentCategory::CARTOON_SCRIPT)
  end
  let(:video_prompt) { create(:video_prompt, prompt: "Camera slowly zooms in as Bloomy waves.") }
  let(:script) { create(:script, script_text: "Bloomy waves hello.", video_prompt:) }
  let(:prompt_message) do
    create(:prompt_message, prompt: video_prompt.prompt, video_prompt:, command_request:)
  end
  let(:parent_request) do
    create(
      :button_video_processing_request,
      :completed,
      command_request:,
      parent_request: prompt_message,
      processor: "veo3_1_lite_image_to_video"
    )
  end
  let(:context) do
    Interactor::Context.build(
      command_request:,
      parent_request:
    )
  end

  before { script unless script.nil? }

  it "succeeds and sets script and video_prompt on context" do
    expect(result).to be_success
    expect(result.script).to eq(script)
    expect(result.video_prompt).to eq(video_prompt)
  end

  context "when parent is a regenerated video request" do
    let(:parent_request) do
      create(
        :button_video_processing_request,
        :completed,
        command_request:,
        parent_request: create(
          :button_video_processing_request,
          :completed,
          command_request:,
          parent_request: prompt_message,
          processor: "veo3_1_lite_image_to_video"
        ),
        processor: "veo3_1_lite_image_to_video"
      )
    end

    it "succeeds using the ancestor prompt message" do
      expect(result).to be_success
      expect(result.script).to eq(script)
      expect(result.video_prompt).to eq(video_prompt)
    end
  end

  context "when script is missing" do
    let(:script) { nil }

    it "fails with CommandUnknownError" do
      expect(result).to be_failure
      expect(result.error).to eq(CommandUnknownError)
    end
  end
end
