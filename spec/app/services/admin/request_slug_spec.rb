require "rails_helper"

describe Admin::RequestSlug do
  describe ".for" do
    subject { described_class.for(class_name) }

    context "when given a command request class name" do
      let(:class_name) { "CommandPromptToImageRequest" }

      it { is_expected.to eq("prompt_to_image") }
    end

    context "when given a button request class name" do
      let(:class_name) { "ButtonMergeAudioVideoProcessingRequest" }

      it { is_expected.to eq("merge_audio_video_processing") }
    end
  end

  describe ".resolve" do
    subject { described_class.resolve(slug, Admin::ButtonRequestTypes::ALL) }

    context "when the slug matches a whitelisted class" do
      let(:slug) { "extend_prompt" }

      it { is_expected.to eq(ButtonExtendPromptRequest) }
    end

    context "when the slug belongs to a class outside the whitelist" do
      let(:slug) { "prompt_to_image" }

      it { is_expected.to be_nil }
    end
  end
end
