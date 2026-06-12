require "rails_helper"

describe MediaGenerator::ButtonHandler::HandleMergeCartoonAudioVideoButton do
  subject(:result) do
    described_class.call(
      button_request: ButtonActions::MERGE_CARTOON_AUDIO_VIDEO,
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
  let(:video_request) do
    create(
      :button_video_processing_request,
      :completed,
      command_request:,
      parent_request: prompt_message,
      processor: "veo3_1_lite_image_to_video",
      video_url: "https://example.com/video.mp4"
    )
  end
  let(:audio_prompt) { create(:audio_prompt, video_prompt:, prompt: "Hi, my name is Bloomy.") }
  let(:parent_request) do
    create(
      :button_audio_processing_request,
      :completed,
      command_request: create(:command_prompt_to_audio_request, user:, chat_id:, category: ContentCategory::CARTOON_SCRIPT),
      parent_request: video_request,
      audio_prompt:,
      audio_url: "https://example.com/audio.mp3"
    )
  end

  before do
    script
    create(:stored_video, source: video_request, video_url: "https://example.com/stored-video.mp4",
                          category: ContentCategory::CARTOON_SCRIPT, subcategory: "scene_1")
    create(:bot_telegram_message, tg_message_id: message_id, chat_id:, request: parent_request)

    allow(Generator::Media::Merge::TaskCreatorJob).to receive(:perform_async)
    allow(TelegramIntegration::SendAnswerCallbackQuery).to receive(:call)
  end

  it "creates a merge request and enqueues generation" do
    expect { result }.to change(ButtonMergeAudioVideoProcessingRequest, :count).by(1)

    merge_request = ButtonMergeAudioVideoProcessingRequest.last

    expect(merge_request.processor).to eq("ffmpeg_merge_audio_video")
    expect(merge_request.parent_request).to eq(parent_request)
    expect(merge_request.source_video_url).to eq("https://example.com/stored-video.mp4")
    expect(merge_request.source_audio_url).to eq("https://example.com/audio.mp3")
    expect(merge_request.command_request).to eq(command_request)

    expect(Generator::Media::Merge::TaskCreatorJob)
      .to have_received(:perform_async)
      .with(merge_request.id)
  end

  context "when video url is missing" do
    before do
      video_request.stored_video.destroy!
      video_request.update!(video_url: nil)
    end

    it "fails with CommandUnknownError" do
      expect(result).to be_failure
      expect(result.error).to eq(CommandUnknownError)
    end
  end
end
