require "rails_helper"

describe MediaGenerator::ButtonHandler::HandleGenerateCartoonVideoButton do
  subject(:result) do
    described_class.call(
      button_request: ButtonActions::GENERATE_CARTOON_VIDEO,
      chat_id:,
      tg_message_id: message_id,
      callback_query_id: "callback-123"
    )
  end

  let(:chat_id) { 456 }
  let(:message_id) { 789 }
  let(:user) { create(:user, :with_balance, chat_id:) }
  let(:image_prompt) { create(:image_prompt, prompt: "Bright kids room interior.") }
  let(:script) { create(:script, script_text: "Bloomy waves hello.", image_prompt:) }
  let(:command_request) do
    create(
      :command_edit_image_request,
      user:,
      chat_id:,
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
  let(:video_prompt_context) { instance_double(ScriptGenerator::ForCartoon::VideoPromptContext, prompt: video_prompt) }

  before do
    script
    create(:bot_telegram_message, tg_message_id: message_id, chat_id:, request: parent_request)
    create(:stored_image, source_message: parent_request, image_url: "https://example.com/scene.png")

    allow(ScriptGenerator::ForCartoon::VideoPromptContext)
      .to receive(:new)
      .with(script_text: script.script_text)
      .and_return(video_prompt_context)

    allow(Generator::Media::Video::EnqueueVideoTask).to receive(:call)
    allow(TelegramIntegration::SendAnswerCallbackQuery).to receive(:call)
  end

  it "shows the processing toast before script generation" do
    allow(ScriptGenerator::ForCartoon::ProcessScriptVideoPrompt).to receive(:call).and_wrap_original do |method, **args|
      expect(TelegramIntegration::SendAnswerCallbackQuery)
        .to have_received(:call)
        .with(
          callback_query_id: "callback-123",
          process_name: I18n.t(
            "telegram.generation.humanized_process_names.video.veo3_1_lite_image_to_video",
            locale: user.locale
          )
        )

      method.call(**args)
    end

    result
  end

  it "creates a veo video request and enqueues generation" do
    expect { result }
      .to change(ButtonVideoProcessingRequest, :count).by(1)
      .and change(PromptMessage, :count).by(1)
      .and change(CommandPromptToVideoRequest, :count).by(1)
      .and change(VideoPrompt, :count).by(1)

    video_request = ButtonVideoProcessingRequest.last

    expect(video_request.processor).to eq("veo3_1_lite_image_to_video")
    expect(video_request.image_url).to eq("https://example.com/scene.png")
    expect(video_request.parent_request).to be_a(PromptMessage)
    expect(video_request.parent_request.prompt).to eq(video_prompt)
    expect(video_request.parent_request.video_prompt).to eq(script.reload.video_prompt)
    expect(script.reload.video_prompt.prompt).to eq(video_prompt)

    expect(Generator::Media::Video::EnqueueVideoTask)
      .to have_received(:call)
      .with(video_request)
  end

  context "when the script already has a video prompt" do
    let!(:existing_video_prompt) { create(:video_prompt, prompt: video_prompt) }

    before { script.update!(video_prompt: existing_video_prompt) }

    it "creates another video request without calling the script API again" do
      expect { result }
        .to change(ButtonVideoProcessingRequest, :count).by(1)
        .and change(PromptMessage, :count).by(1)
        .and change(CommandPromptToVideoRequest, :count).by(1)
        .and change(VideoPrompt, :count).by(0)

      expect(ScriptGenerator::ForCartoon::VideoPromptContext).not_to have_received(:new)

      video_request = ButtonVideoProcessingRequest.last

      expect(video_request.parent_request.video_prompt).to eq(existing_video_prompt)
      expect(script.reload.video_prompt).to eq(existing_video_prompt)
    end
  end

  context "when command request is not cartoon script" do
    let(:command_request) do
      create(:command_edit_image_request, user:, chat_id:, category: nil, image_prompt:)
    end

    it "fails with CommandUnknownError" do
      expect(result).to be_failure
      expect(result.error).to eq(CommandUnknownError)
    end
  end
end
