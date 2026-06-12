require "rails_helper"

describe MediaGenerator::ButtonHandler::HandleGenerateCartoonAudioButton do
  subject(:result) do
    described_class.call(
      button_request: ButtonActions::GENERATE_CARTOON_AUDIO,
      chat_id:,
      tg_message_id: message_id,
      callback_query_id: "callback-123"
    )
  end

  let(:chat_id) { 456 }
  let(:message_id) { 789 }
  let(:user) { create(:user, :with_balance, chat_id:) }
  let(:video_prompt) { create(:video_prompt, prompt: "Camera slowly zooms in as Bloomy waves.") }
  let(:script) { create(:script, script_text: "Bloomy waves hello.", video_prompt:) }
  let(:command_request) do
    create(
      :command_prompt_to_video_request,
      user:,
      chat_id:,
      category: ContentCategory::CARTOON_SCRIPT
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
  let(:audio_prompt_context) { instance_double(ScriptGenerator::ForCartoon::AudioPromptContext, prompt: audio_prompt_text) }

  before do
    script
    create(:bot_telegram_message, tg_message_id: message_id, chat_id:, request: parent_request)

    allow(ScriptGenerator::ForCartoon::AudioPromptContext)
      .to receive(:new)
      .with(script_text: script.script_text)
      .and_return(audio_prompt_context)

    allow(Generator::Media::Audio::TaskCreatorJob).to receive(:perform_async)
    allow(TelegramIntegration::SendAnswerCallbackQuery).to receive(:call)
  end

  it "creates an audio request and enqueues generation" do
    expect { result }
      .to change(ButtonAudioProcessingRequest, :count).by(1)
      .and change(CommandPromptToAudioRequest, :count).by(1)
      .and change(AudioPrompt, :count).by(1)

    audio_request = ButtonAudioProcessingRequest.last

    expect(audio_request.processor).to eq("elevenlabs_v3_audio")
    expect(audio_request.voice).to eq("lulu_lollipop")
    expect(audio_request.parent_request).to eq(parent_request)
    expect(audio_request.audio_prompt.prompt).to eq(audio_prompt_text)
    expect(audio_request.command_request.category).to eq(ContentCategory::CARTOON_SCRIPT)

    expect(Generator::Media::Audio::TaskCreatorJob)
      .to have_received(:perform_async)
      .with(audio_request.id)
  end

  context "when command request is cartoon shorts script" do
    let(:command_request) do
      create(
        :command_prompt_to_video_request,
        user:,
        chat_id:,
        category: ContentCategory::CARTOON_SHORTS_SCRIPT
      )
    end

    it "creates audio request with cartoon shorts category" do
      result

      expect(ButtonAudioProcessingRequest.last.command_request.category)
        .to eq(ContentCategory::CARTOON_SHORTS_SCRIPT)
    end
  end

  context "when command request is not cartoon script" do
    let(:command_request) do
      create(:command_prompt_to_video_request, user:, chat_id:, category: nil)
    end

    it "fails with CommandUnknownError" do
      expect(result).to be_failure
      expect(result.error).to eq(CommandUnknownError)
    end
  end
end
