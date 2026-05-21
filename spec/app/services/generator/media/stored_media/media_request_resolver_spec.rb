require "rails_helper"

describe Generator::Media::StoredMedia::MediaRequestResolver do
  describe "#media_request" do
    subject(:resolved_request) { described_class.new(processor:, button_request_id:).media_request }

    let(:button_request_id) { button_request.id }

    context "when processor is image" do
      let(:processor) { Generator::Processors::IMAGE.first }
      let(:button_request) { create(:button_image_processing_request) }

      it "returns button image processing request" do
        expect(resolved_request).to eq(button_request)
      end
    end

    context "when processor is audio" do
      let(:processor) { Generator::Processors::AUDIO.first }
      let(:button_request) { create(:button_audio_processing_request) }

      it "returns button audio processing request" do
        expect(resolved_request).to eq(button_request)
      end
    end

    context "when processor is video" do
      let(:processor) { Generator::Processors::VIDEO.first }
      let(:button_request) { create(:button_video_processing_request) }

      it "returns button video processing request" do
        expect(resolved_request).to eq(button_request)
      end
    end

    context "when processor is prompt extension" do
      let(:processor) { Generator::Processors::PROMPT_EXTENSION }
      let(:button_request) { create(:button_image_processing_request) }

      it "returns button image processing request" do
        expect(resolved_request).to eq(button_request)
      end
    end
  end
end
