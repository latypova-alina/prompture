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
  let(:video_prompt_context) { instance_double(ScriptGenerator::ForCartoon::VideoPromptContext, video_prompt:) }

  before do
    script
    create(:bot_telegram_message, tg_message_id: message_id, chat_id:, request: parent_request)
    create(:stored_image, source_message: parent_request, image_url: "https://example.com/scene.png")

    allow(ScriptGenerator::ForCartoon::VideoPromptContext)
      .to receive(:new)
      .with(script_text: script.script_text)
      .and_return(video_prompt_context)

    allow(Generator::Media::Video::TaskCreatorJob).to receive(:perform_async)
    allow(TelegramIntegration::SendAnswerCallbackQuery).to receive(:call)
  end

  it "creates a hailuo video request and enqueues generation" do
    expect { result }
      .to change(ButtonVideoProcessingRequest, :count).by(1)
      .and change(PromptMessage, :count).by(1)
      .and change(CommandPromptToVideoRequest, :count).by(1)
      .and change(VideoPrompt, :count).by(1)

    video_request = ButtonVideoProcessingRequest.last

    expect(video_request.processor).to eq("hailuo_02_standard_image_to_video")
    expect(video_request.image_url).to eq("https://example.com/scene.png")
    expect(video_request.parent_request).to be_a(PromptMessage)
    expect(video_request.parent_request.prompt).to eq(video_prompt)
    expect(script.reload.video_prompt.prompt).to eq(video_prompt)

    expect(Generator::Media::Video::TaskCreatorJob)
      .to have_received(:perform_async)
      .with(video_request.id)
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
