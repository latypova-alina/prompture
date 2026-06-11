require "rails_helper"

describe Generator::Media::TaskRetrieverContext do
  describe ".for" do
    Generator::Processors::IMAGE.each do |image_processor|
      context "when processor is #{image_processor}" do
        let(:params) { ActionController::Parameters.new(processor: image_processor) }

        it "returns FalImageTaskRetrieverContext" do
          expect(described_class.for(params:))
            .to be_a(Generator::Media::FalImageTaskRetrieverContext)
        end
      end
    end

    Generator::Processors::VIDEO.each do |video_processor|
      context "when processor is #{video_processor}" do
        let(:params) { ActionController::Parameters.new(processor: video_processor) }

        it "returns FalVideoTaskRetrieverContext" do
          expect(described_class.for(params:))
            .to be_a(Generator::Media::FalVideoTaskRetrieverContext)
        end
      end
    end

    Generator::Processors::AUDIO.each do |audio_processor|
      context "when processor is #{audio_processor}" do
        let(:params) { ActionController::Parameters.new(processor: audio_processor) }

        it "returns FalAudioTaskRetrieverContext" do
          expect(described_class.for(params:))
            .to be_a(Generator::Media::FalAudioTaskRetrieverContext)
        end
      end
    end

    context "when processor uses freepik webhook" do
      let(:params) { ActionController::Parameters.new(processor: "extend_prompt") }

      it "returns FreepikTaskRetrieverContext" do
        expect(described_class.for(params:))
          .to be_a(Generator::Media::FreepikTaskRetrieverContext)
      end
    end
  end
end
