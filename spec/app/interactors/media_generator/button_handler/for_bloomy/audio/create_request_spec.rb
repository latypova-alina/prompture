require "rails_helper"

describe MediaGenerator::ButtonHandler::ForBloomy::Audio::CreateRequest do
  subject(:result) do
    described_class.call(
      parent_request:,
      scene:,
      video_prompt:
    )
  end

  let(:user) { create(:user, :with_balance) }
  let(:video_prompt) { create(:video_prompt, prompt: "Camera slowly zooms in as Bloomy waves.") }
  let(:scene) { create(:scene, scene_text: "Bloomy waves hello.", video_prompt:) }
  let(:command_request) do
    create(
      :command_prompt_to_video_request,
      user:,
      category: ContentCategory::BLOOMY_CARTOON_SCRIPT
    )
  end
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
  let(:audio_prompt_text) { "Hi, my name is Bloomy. Let's explore my world together!" }
  let(:audio_prompt_record) { create(:audio_prompt, prompt: audio_prompt_text) }

  before do
    allow(ScriptGenerator::ForBloomy::Processors::ForAudioPrompt)
      .to receive(:call)
      .with(script_text: scene.scene_text, video_prompt:)
      .and_return(audio_prompt_record)
  end

  it "creates an audio request with cartoon category" do
    expect { result }
      .to change(ButtonAudioProcessingRequest, :count).by(1)
      .and change(CommandPromptToAudioRequest, :count).by(1)

    audio_request = result.button_request_record

    expect(result).to be_success
    expect(result.button_request).to eq("elevenlabs_v3_audio")
    expect(audio_request.processor).to eq("elevenlabs_v3_audio")
    expect(audio_request.voice).to eq("lulu_lollipop")
    expect(audio_request.parent_request).to eq(parent_request)
    expect(audio_request.audio_prompt).to eq(audio_prompt_record)
    expect(audio_request.command_request.category).to eq(ContentCategory::BLOOMY_CARTOON_SCRIPT)
    expect(audio_request.command_request.user).to eq(user)
  end

  context "when command request is cartoon shorts script" do
    let(:command_request) do
      create(
        :command_prompt_to_video_request,
        user:,
        category: ContentCategory::CARTOON_BLOOMY_SHORTS_SCRIPT
      )
    end

    it "creates audio request with cartoon shorts category" do
      result

      expect(result.button_request_record.command_request.category)
        .to eq(ContentCategory::CARTOON_BLOOMY_SHORTS_SCRIPT)
    end
  end
end
