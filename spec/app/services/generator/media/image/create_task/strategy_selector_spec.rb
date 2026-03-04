require "rails_helper"

describe Generator::Media::Image::CreateTask::StrategySelector do
  subject(:selector) { described_class.new(request) }

  let(:parent_prompt) { "little kitten" }

  let(:parent_request) do
    instance_double("PromptMessage", parent_prompt:)
  end

  let(:request) do
    instance_double(
      ButtonImageProcessingRequest,
      processor:,
      parent_request:
    )
  end

  describe "#strategy" do
    context "when processor is mystic_image" do
      let(:processor) { "mystic_image" }

      it "returns MysticPayloadStrategy initialized with parent_prompt" do
        strategy = selector.strategy

        expect(strategy)
          .to be_a(Generator::Media::Image::CreateTask::MysticPayloadStrategy)

        expect(strategy.prompt).to eq(parent_prompt)
      end
    end

    context "when processor is gemini_image" do
      let(:processor) { "gemini_image" }

      it "returns GeminiPayloadStrategy initialized with parent_prompt" do
        strategy = selector.strategy

        expect(strategy)
          .to be_a(Generator::Media::Image::CreateTask::GeminiPayloadStrategy)

        expect(strategy.prompt).to eq(parent_prompt)
      end
    end

    context "when processor is imagen_image" do
      let(:processor) { "imagen_image" }

      it "returns ImagenPayloadStrategy initialized with parent_prompt" do
        strategy = selector.strategy

        expect(strategy)
          .to be_a(Generator::Media::Image::CreateTask::ImagenPayloadStrategy)

        expect(strategy.prompt).to eq(parent_prompt)
      end
    end

    context "when processor is unknown" do
      let(:processor) { "unknown_processor" }

      it "raises KeyError" do
        expect { selector.strategy }.to raise_error(KeyError)
      end
    end
  end
end
