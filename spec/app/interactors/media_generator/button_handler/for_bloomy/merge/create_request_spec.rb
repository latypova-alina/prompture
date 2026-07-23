require "rails_helper"

describe MediaGenerator::ButtonHandler::ForBloomy::Merge::CreateRequest do
  subject(:result) do
    described_class.call(
      audio_request:,
      button_video_processing_request: video_request
    )
  end

  let(:user) { create(:user, :with_balance) }
  let(:video_request) do
    create(
      :button_video_processing_request,
      :completed,
      command_request: create(
        :command_prompt_to_video_request,
        user:,
        category: ContentCategory::BLOOMY_CARTOON_SCRIPT
      ),
      video_url: "https://example.com/video.mp4"
    )
  end
  let(:audio_prompt) { create(:audio_prompt) }
  let(:audio_request) do
    create(
      :button_audio_processing_request,
      :completed,
      command_request: create(
        :command_prompt_to_audio_request,
        user:,
        category: ContentCategory::BLOOMY_CARTOON_SCRIPT
      ),
      parent_request: video_request,
      audio_prompt:
    )
  end

  it "creates a merge request from audio and video urls" do
    expect { result }.to change(ButtonMergeAudioVideoProcessingRequest, :count).by(1)

    merge_request = result.button_request_record

    expect(result).to be_success
    expect(result.button_request).to eq("local_ffmpeg_merge")
    expect(merge_request.processor).to eq("local_ffmpeg_merge")
    expect(merge_request.parent_request).to eq(audio_request)
    expect(merge_request.source_video_url).to eq("https://example.com/video.mp4")
    expect(merge_request.source_audio_url).to eq(audio_request.audio_url)
    expect(merge_request.command_request).to eq(video_request.command_request)
  end
end
