require "rails_helper"

RSpec.describe ButtonMergeAudioVideoProcessingRequest do
  subject(:request) { build(:button_merge_audio_video_processing_request) }

  describe "validations" do
    it "is valid with required attributes" do
      expect(request).to be_valid
    end

    it "is invalid without source_video_url" do
      request.source_video_url = nil

      expect(request).not_to be_valid
      expect(request.errors[:source_video_url]).to be_present
    end

    it "is invalid without source_audio_url" do
      request.source_audio_url = nil

      expect(request).not_to be_valid
      expect(request.errors[:source_audio_url]).to be_present
    end

    it "is invalid with an unknown processor" do
      request.processor = "unknown_processor"

      expect(request).not_to be_valid
      expect(request.errors[:processor]).to be_present
    end
  end

  describe "#cost" do
    it "uses processor pricing" do
      expect(request.cost).to eq(COSTS[:merge_audio_video][:local_ffmpeg_merge])
    end
  end

  describe "#humanized_process_name" do
    it "returns translated processor name" do
      expect(request.humanized_process_name)
        .to eq(I18n.t("telegram.generation.humanized_process_names.merge.local_ffmpeg_merge",
                      locale: request.locale))
    end
  end
end
