require "rails_helper"

describe Strategies::GenerateVideo do
  let(:session) { { "image_prompt" => "generate image prompt", "image_url" => "some_image_url" } }
  let(:processor_type) { "kling_2_1_pro_image_to_video" }
  let(:processor_object) { double(video_url: "https://example.com/video.mp4") }
  let(:presenter_object) { double(reply_data: "reply data") }

  subject { described_class.new(session, processor_type) }

  describe "#reply_data" do
    subject { super().reply_data }

    before do
      allow(VideoProcessor).to receive(:new)
        .with("some_image_url", "generate image prompt", processor_type).and_return(processor_object)

      allow(ButtonMessagePresenter).to receive(:new)
        .with("https://example.com/video.mp4", "video_message", processor_type).and_return(presenter_object)
    end

    it { is_expected.to eq("reply data") }
  end
end
