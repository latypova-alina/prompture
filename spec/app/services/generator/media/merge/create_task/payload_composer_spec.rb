require "rails_helper"

describe Generator::Media::Merge::CreateTask::PayloadComposer do
  subject(:composer) { described_class.new(request, strategy) }

  let(:request) do
    create(:button_merge_audio_video_processing_request, processor: "ffmpeg_merge_audio_video")
  end

  let(:strategy_payload) do
    {
      video_url: "https://example.com/video.mp4",
      audio_url: "https://example.com/audio.mp3"
    }
  end
  let(:strategy) { instance_double("Strategy", payload: strategy_payload) }
  let(:webhook_url) { "https://example.com/webhook" }

  before do
    allow(Generator::Media::WebhookUrlBuilder)
      .to receive(:new)
      .with(processor: "ffmpeg_merge_audio_video", button_request_id: request.id)
      .and_return(double(webhook_url:))
  end

  describe "#final_payload" do
    it "merges strategy payload with webhook_url" do
      expect(composer.final_payload).to eq(
        video_url: "https://example.com/video.mp4",
        audio_url: "https://example.com/audio.mp3",
        webhook_url:
      )
    end
  end
end
