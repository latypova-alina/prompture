require "rails_helper"

describe MediaGenerator::ButtonHandler::ValidateCartoonAudioMergeRequest do
  subject(:result) { described_class.call(context) }

  let(:command_request) do
    create(:command_prompt_to_video_request, category: ContentCategory::CARTOON_SCRIPT)
  end
  let(:video_request) do
    create(
      :button_video_processing_request,
      :completed,
      command_request:,
      video_url: "https://example.com/video.mp4"
    )
  end
  let(:audio_prompt) { create(:audio_prompt) }
  let(:audio_request) do
    create(
      :button_audio_processing_request,
      :completed,
      command_request: create(:command_prompt_to_audio_request, category: ContentCategory::CARTOON_SCRIPT),
      parent_request: video_request,
      audio_prompt:
    )
  end
  let(:context) do
    Interactor::Context.build(
      command_request:,
      audio_request:,
      button_video_processing_request: video_request
    )
  end

  it "succeeds when merge prerequisites are met" do
    expect(result).to be_success
  end

  context "when audio url is missing" do
    before { audio_request.update!(audio_url: nil) }

    it "fails with CommandUnknownError" do
      expect(result).to be_failure
      expect(result.error).to eq(CommandUnknownError)
    end
  end

  context "when video url is missing" do
    before { video_request.update!(video_url: nil) }

    it "fails with CommandUnknownError" do
      expect(result).to be_failure
      expect(result.error).to eq(CommandUnknownError)
    end
  end

  context "when audio prompt is missing" do
    before { audio_request.update!(audio_prompt: nil) }

    it "fails with CommandUnknownError" do
      expect(result).to be_failure
      expect(result.error).to eq(CommandUnknownError)
    end
  end

  context "when audio is not completed" do
    before { audio_request.update!(status: "PENDING") }

    it "fails with CommandUnknownError" do
      expect(result).to be_failure
      expect(result.error).to eq(CommandUnknownError)
    end
  end
end
