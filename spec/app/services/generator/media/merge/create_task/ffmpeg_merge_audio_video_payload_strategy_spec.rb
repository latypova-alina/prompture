require "rails_helper"

describe Generator::Media::Merge::CreateTask::FfmpegMergeAudioVideoPayloadStrategy do
  subject(:strategy) { described_class.new(video_url:, audio_url:) }

  let(:video_url) { "https://example.com/video.mp4" }
  let(:audio_url) { "https://example.com/audio.mp3" }

  describe "#payload" do
    it "returns video and audio urls for fal merge endpoint" do
      expect(strategy.payload).to eq(
        video_url:,
        audio_url:
      )
    end
  end

  describe "#api_url" do
    it "points to fal ffmpeg merge queue endpoint" do
      expect(strategy.api_url).to eq("https://queue.fal.run/fal-ai/ffmpeg-api/merge-audio-video")
    end
  end
end
