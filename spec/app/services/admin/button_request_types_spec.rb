require "rails_helper"

describe Admin::ButtonRequestTypes do
  describe ".processor_options" do
    subject(:processor_options) { described_class.processor_options }

    it "includes processors from types that have them" do
      expect(processor_options).to include("flux_image", "elevenlabs_v3_audio", "local_ffmpeg_merge")
    end

    it "does not error on the type without a processor column" do
      expect { processor_options }.not_to raise_error
    end
  end

  describe ".media_association_for" do
    it { expect(described_class.media_association_for(ButtonImageProcessingRequest)).to eq(:stored_image) }
    it { expect(described_class.media_association_for(ButtonVideoProcessingRequest)).to eq(:stored_video) }
    it { expect(described_class.media_association_for(ButtonAudioProcessingRequest)).to be_nil }
  end
end
