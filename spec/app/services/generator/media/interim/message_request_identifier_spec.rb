require "rails_helper"

describe Generator::Media::Interim::MessageRequestIdentifier do
  subject(:request_class) { described_class.new(processor:).request_class }

  context "when processor is an image processor" do
    let(:processor) { "flux_image" }

    it { is_expected.to eq(ButtonImageProcessingRequest) }
  end

  context "when processor is a video processor" do
    let(:processor) { "kling_2_1_pro_image_to_video" }

    it { is_expected.to eq(ButtonVideoProcessingRequest) }
  end

  context "when processor does not use interim messages" do
    let(:processor) { "elevenlabs_v3_audio" }

    it { is_expected.to be_nil }
  end
end
