require "rails_helper"

describe Generator::Media::StoredMedia::StorePolicy do
  subject(:policy) { described_class.new(processor:) }

  describe "#needs_to_be_stored?" do
    context "when processor is image" do
      let(:processor) { Generator::Processors::IMAGE.first }

      it { is_expected.to be_needs_to_be_stored }
    end

    context "when processor is audio" do
      let(:processor) { Generator::Processors::AUDIO.first }

      it { is_expected.to be_needs_to_be_stored }
    end

    context "when processor is video" do
      let(:processor) { Generator::Processors::VIDEO.first }

      it { is_expected.to be_needs_to_be_stored }
    end

    context "when processor is merge" do
      let(:processor) { Generator::Processors::MERGE.first }

      it { is_expected.to be_needs_to_be_stored }
    end

    context "when processor is unknown" do
      let(:processor) { "some_unknown_processor" }

      it { is_expected.not_to be_needs_to_be_stored }
    end
  end
end
