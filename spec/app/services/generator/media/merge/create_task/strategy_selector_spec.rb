require "rails_helper"

describe Generator::Media::Merge::CreateTask::StrategySelector do
  subject(:strategy) { described_class.new(request).strategy }

  let(:request) do
    create(
      :button_merge_audio_video_processing_request,
      source_video_url: "https://example.com/video.mp4",
      source_audio_url: "https://example.com/audio.mp3"
    )
  end

  describe "#strategy" do
    it "returns FfmpegMergeAudioVideoPayloadStrategy with source urls" do
      expect(strategy)
        .to be_a(Generator::Media::Merge::CreateTask::FfmpegMergeAudioVideoPayloadStrategy)

      expect(strategy.payload).to eq(
        video_url: "https://example.com/video.mp4",
        audio_url: "https://example.com/audio.mp3",
        start_offset: 1
      )
    end
  end

  context "when processor is not supported" do
    let(:request) { build(:button_merge_audio_video_processing_request, processor: "unknown_processor") }

    it "raises KeyError" do
      expect { strategy }.to raise_error(KeyError)
    end
  end
end
