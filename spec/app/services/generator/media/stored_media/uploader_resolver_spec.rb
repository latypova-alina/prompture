require "rails_helper"

describe Generator::Media::StoredMedia::UploaderResolver do
  describe "#uploader_class" do
    subject(:uploader_class) { described_class.new(processor:).uploader_class }

    context "when processor is image" do
      let(:processor) { Generator::Processors::IMAGE.first }

      it { is_expected.to eq(Generator::Media::StoredMedia::Uploader) }
    end

    context "when processor is audio" do
      let(:processor) { Generator::Processors::AUDIO.first }

      it { is_expected.to eq(Generator::Media::StoredMedia::AudioUploader) }
    end

    context "when processor is video" do
      let(:processor) { Generator::Processors::VIDEO.first }

      it { is_expected.to eq(Generator::Media::StoredMedia::VideoUploader) }
    end

    context "when processor is prompt extension" do
      let(:processor) { Generator::Processors::PROMPT_EXTENSION }

      it { is_expected.to eq(Generator::Media::StoredMedia::Uploader) }
    end
  end
end
