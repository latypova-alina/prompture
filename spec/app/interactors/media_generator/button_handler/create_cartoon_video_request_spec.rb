require "rails_helper"

describe MediaGenerator::ButtonHandler::CreateCartoonVideoRequest do
  subject(:result) do
    described_class.call(
      parent_request:,
      command_request:,
      scene:
    )
  end

  let(:user) { create(:user, :with_balance) }
  let(:image_prompt) { create(:image_prompt, prompt: "Bright kids room interior.") }
  let(:scene) { create(:scene, scene_text: "Bloomy waves hello.", image_prompt:) }
  let(:command_request) do
    create(
      :command_edit_image_request,
      user:,
      category: ContentCategory::BLOOMY_CARTOON_SCRIPT,
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
  let(:video_prompt_record) { create(:video_prompt, prompt: video_prompt) }

  before do
    allow(ScriptGenerator::ForBloomy::Processors::ForVideoPrompt)
      .to receive(:call)
      .with(scene:)
      .and_return(video_prompt_record)
  end

  it "creates records and sets context for video generation" do
    create(:stored_image, source_message: parent_request, image_url: "https://example.com/scene.png")
    expect { result }
      .to change(ButtonVideoProcessingRequest, :count).by(1)
      .and change(PromptMessage, :count).by(1)
      .and change(CommandPromptToVideoRequest, :count).by(1)

    video_request = result.button_request_record

    expect(result).to be_success
    expect(result.button_request).to eq("veo3_1_lite_image_to_video")
    expect(video_request.processor).to eq("veo3_1_lite_image_to_video")
    expect(video_request.image_url).to eq("https://example.com/scene.png")
    expect(video_request.parent_request).to be_a(PromptMessage)
    expect(video_request.parent_request.prompt).to eq(video_prompt)
    expect(video_request.parent_request.video_prompt).to eq(video_prompt_record)
    expect(video_request.command_request).to be_a(CommandPromptToVideoRequest)
    expect(video_request.command_request.category).to eq(ContentCategory::BLOOMY_CARTOON_SCRIPT)
    expect(video_request.command_request.user).to eq(user)
  end

  it "fetches the video prompt from the scene passed on context" do
    create(:stored_image, source_message: parent_request, image_url: "https://example.com/scene.png")

    result

    expect(ScriptGenerator::ForBloomy::Processors::ForVideoPrompt)
      .to have_received(:call)
      .with(scene:)
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
