require "rails_helper"

describe Generator::Media::StoredMedia::StoredMediaType do
  subject(:stored_media_type) { described_class.new(processor:, media_url:, button_request_id:) }

  let(:media_url) { "https://ai-statics.freepik.com/generated.png" }
  let(:button_request_id) { button_request.id }

  describe "#needs_to_be_stored?" do
    context "when processor is image" do
      let(:processor) { Generator::Processors::IMAGE.first }
      let(:button_request) { create(:button_image_processing_request) }

      it { is_expected.to be_needs_to_be_stored }
    end

    context "when processor is audio" do
      let(:processor) { Generator::Processors::AUDIO.first }
      let(:button_request) { create(:button_audio_processing_request) }

      it { is_expected.to be_needs_to_be_stored }
    end

    context "when processor is not image or audio" do
      let(:processor) { Generator::Processors::PROMPT_EXTENSION }
      let(:button_request) { create(:button_image_processing_request) }

      it { is_expected.not_to be_needs_to_be_stored }
    end

    context "when processor is video with storable category" do
      let(:processor) { Generator::Processors::VIDEO.first }
      let(:button_request) do
        create(
          :button_video_processing_request,
          command_request: create(:command_prompt_to_video_request, :motivation)
        )
      end

      it { is_expected.to be_needs_to_be_stored }
    end

    context "when processor is video without category" do
      let(:processor) { Generator::Processors::VIDEO.first }
      let(:button_request) { create(:button_video_processing_request) }

      it { is_expected.not_to be_needs_to_be_stored }
    end
  end

  describe "#uploader" do
    let(:media_url) { "https://ai-statics.freepik.com/generated.mp3" }

    context "when processor is image" do
      let(:processor) { Generator::Processors::IMAGE.first }
      let(:button_request) { create(:button_image_processing_request) }

      it "returns image uploader" do
        expect(stored_media_type.uploader).to be_a(Generator::Media::StoredMedia::Uploader)
      end
    end

    context "when processor is audio" do
      let(:processor) { Generator::Processors::AUDIO.first }
      let(:button_request) { create(:button_audio_processing_request) }

      it "returns audio uploader" do
        expect(stored_media_type.uploader).to be_a(Generator::Media::StoredMedia::AudioUploader)
      end
    end

    context "when processor is video with storable category" do
      let(:processor) { Generator::Processors::VIDEO.first }
      let(:button_request) do
        create(
          :button_video_processing_request,
          command_request: create(:command_prompt_to_video_request, :motivation)
        )
      end

      it "returns video uploader" do
        expect(stored_media_type.uploader).to be_a(Generator::Media::StoredMedia::VideoUploader)
      end
    end
  end
end
