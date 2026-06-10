require "rails_helper"

describe Generator::Media::Video::CreateTask::StrategySelector do
  subject(:strategy) { described_class.new(request).strategy }

  let(:parent_prompt) { "little kitten" }

  let(:parent_request) { create(:prompt_message, prompt: parent_prompt) }

  let(:request) { create(:button_video_processing_request, parent_request:) }

  describe "#strategy" do
    context "when processor is kling" do
      it "returns KlingPayloadStrategy initialized with parent prompt" do
        expect(strategy)
          .to be_a(Generator::Media::Video::CreateTask::KlingPayloadStrategy)

        expect(strategy.prompt).to eq(parent_prompt)
      end
    end

    context "when processor is hailuo 02 standard" do
      let(:request) do
        create(:button_video_processing_request, parent_request:, processor: "hailuo_02_standard_image_to_video")
      end

      it "returns Hailuo02StandardPayloadStrategy initialized with parent prompt" do
        expect(strategy)
          .to be_a(Generator::Media::Video::CreateTask::Hailuo02StandardPayloadStrategy)

        expect(strategy.prompt).to eq(parent_prompt)
      end
    end

    context "when processor is veo 3.1 lite" do
      let(:request) do
        create(:button_video_processing_request, parent_request:, processor: "veo3_1_lite_image_to_video")
      end

      it "returns Veo31LitePayloadStrategy initialized with parent prompt" do
        expect(strategy)
          .to be_a(Generator::Media::Video::CreateTask::Veo31LitePayloadStrategy)

        expect(strategy.prompt).to eq(parent_prompt)
      end
    end
  end

  context "when parent_request has no parent_prompt method" do
    let(:parent_request) { create(:command_prompt_to_video_request) }
    let(:default_prompt) { "Animate the image naturally with realistic motion and camera movement." }

    it "uses the default prompt for kling" do
      expect(strategy.prompt).to eq(default_prompt)
    end

    context "when processor is hailuo 02 standard" do
      let(:request) do
        create(:button_video_processing_request, parent_request:, processor: "hailuo_02_standard_image_to_video")
      end

      it "uses the default prompt" do
        expect(strategy.prompt).to eq(default_prompt)
      end
    end

    context "when processor is veo 3.1 lite" do
      let(:request) do
        create(:button_video_processing_request, parent_request:, processor: "veo3_1_lite_image_to_video")
      end

      it "uses the default prompt" do
        expect(strategy.prompt).to eq(default_prompt)
      end
    end
  end

  context "when processor is not supported" do
    let(:request) do
      double(
        processor: "unknown_processor",
        parent_request:
      )
    end

    it "raises KeyError" do
      expect { strategy }.to raise_error(KeyError)
    end
  end
end
