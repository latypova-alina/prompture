require "rails_helper"

describe Generator::Media::Image::CreateTask::StrategySelector do
  subject(:selector) { described_class.new(request) }

  let(:parent_prompt) { "little kitten" }

  let(:parent_request) do
    create(:prompt_message, prompt: parent_prompt)
  end

  let(:request) do
    create(:button_image_processing_request, parent_request:, processor:)
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

    context "when processor is flux_image" do
      let(:processor) { "flux_image" }

      it "returns FluxPayloadStrategy initialized with parent_prompt" do
        strategy = selector.strategy

        expect(strategy)
          .to be_a(Generator::Media::Image::CreateTask::FluxPayloadStrategy)

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

    context "when parent_request has no parent_prompt method" do
      let(:processor) { "mystic_image" }
      let(:parent_request) { create(:command_prompt_to_image_request) }

      it "initializes strategy with nil prompt" do
        strategy = selector.strategy

        expect(strategy.prompt).to be_nil
      end
    end
  end
end
