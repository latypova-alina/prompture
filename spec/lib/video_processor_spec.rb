require "rails_helper"

describe VideoProcessor do
  let(:processor_type) { "mystic_image" }
  let(:image_url) { "http://example.com/image.png" }
  let(:video_url) { "http://example.com/video.mp4" }

  subject { described_class.new(image_url, nil, processor_type) }

  describe "#video_url" do
    subject { super().video_url }

    before do
      allow_any_instance_of(VideoProcessor).to receive(:video_url).and_return(video_url)
    end

    it { is_expected.to eq("http://example.com/video.mp4") }
  end
end
