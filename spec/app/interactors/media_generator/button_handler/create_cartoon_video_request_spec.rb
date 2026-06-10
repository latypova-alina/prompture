require "rails_helper"

describe MediaGenerator::ButtonHandler::CreateCartoonVideoRequest do
  subject(:result) do
    described_class.call(
      parent_request:,
      command_request:,
      script:
    )
  end

  let(:user) { create(:user, :with_balance) }
  let(:image_prompt) { create(:image_prompt, prompt: "Bright kids room interior.") }
  let(:script) { create(:script, script_text: "Bloomy waves hello.", image_prompt:) }
  let(:command_request) do
    create(
      :command_edit_image_request,
      user:,
      category: ContentCategory::CARTOON_SCRIPT,
      image_prompt:
    )
  end
  let(:parent_request) do
    create(
      :button_image_processing_request,
      :completed,
      command_request:,
      parent_request: command_request,
      processor: "nano_banana_edit_image"
    )
  end
  let(:video_prompt) { "Camera slowly zooms in as Bloomy waves." }

  before do
    allow(ScriptGenerator::ForCartoon::ProcessScriptVideoPrompt)
      .to receive(:call)
      .with(script:)
      .and_return(video_prompt)
  end

  it "creates records and sets context for video generation" do
    create(:stored_image, source_message: parent_request, image_url: "https://example.com/scene.png")
    expect { result }
      .to change(ButtonVideoProcessingRequest, :count).by(1)
      .and change(PromptMessage, :count).by(1)
      .and change(CommandPromptToVideoRequest, :count).by(1)

    video_request = result.button_request_record

    expect(result).to be_success
    expect(result.button_request).to eq("hailuo_02_standard_image_to_video")
    expect(video_request.processor).to eq("hailuo_02_standard_image_to_video")
    expect(video_request.image_url).to eq("https://example.com/scene.png")
    expect(video_request.parent_request).to be_a(PromptMessage)
    expect(video_request.parent_request.prompt).to eq(video_prompt)
    expect(video_request.command_request).to be_a(CommandPromptToVideoRequest)
    expect(video_request.command_request.category).to eq(ContentCategory::CARTOON_SCRIPT)
    expect(video_request.command_request.user).to eq(user)
  end

  it "fetches the video prompt from the script passed on context" do
    create(:stored_image, source_message: parent_request, image_url: "https://example.com/scene.png")

    result

    expect(ScriptGenerator::ForCartoon::ProcessScriptVideoPrompt)
      .to have_received(:call)
      .with(script:)
  end

  context "when image is not ready" do
    let(:parent_request) do
      create(
        :button_image_processing_request,
        command_request:,
        parent_request: command_request,
        processor: "nano_banana_edit_image"
      )
    end

    it "fails with ImageNotReadyError" do
      expect(result).to be_failure
      expect(result.error).to eq(ImageNotReadyError)
    end
  end
end
