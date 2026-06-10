require "rails_helper"

describe Generator::Media::StoredMedia::StorePolicy do
  subject(:policy) { described_class.new(processor:, command_request:) }

  describe "#needs_to_be_stored?" do
    context "when processor is image" do
      let(:processor) { Generator::Processors::IMAGE.first }
      let(:command_request) { create(:command_prompt_to_video_request) }

      it { is_expected.to be_needs_to_be_stored }
    end

    context "when processor is audio" do
      let(:processor) { Generator::Processors::AUDIO.first }
      let(:command_request) { create(:command_prompt_to_audio_request) }

      it { is_expected.to be_needs_to_be_stored }
    end

    context "when processor is video with storable category" do
      let(:processor) { Generator::Processors::VIDEO.first }
      let(:command_request) { create(:command_prompt_to_video_request, :motivation) }

      it { is_expected.to be_needs_to_be_stored }
    end

    context "when processor is video with cartoon script category" do
      let(:processor) { Generator::Processors::VIDEO.first }
      let(:command_request) do
        create(:command_prompt_to_video_request, category: ContentCategory::CARTOON_SCRIPT)
      end

      it { is_expected.to be_needs_to_be_stored }
    end

    context "when processor is video without category" do
      let(:processor) { Generator::Processors::VIDEO.first }
      let(:command_request) { create(:command_prompt_to_video_request) }

      it { is_expected.not_to be_needs_to_be_stored }
    end

    context "when processor is video with non-allowlisted category" do
      let(:processor) { Generator::Processors::VIDEO.first }
      let(:command_request) do
        create(:command_prompt_to_video_request, category: ContentCategory::RANDOM_CHARACTER)
      end

      it { is_expected.not_to be_needs_to_be_stored }
    end

    context "when processor is video with image-to-video command" do
      let(:processor) { Generator::Processors::VIDEO.first }
      let(:command_request) { create(:command_image_to_video_request) }

      it { is_expected.not_to be_needs_to_be_stored }
    end
  end
end
