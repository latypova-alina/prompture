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
    context "when processor is flux_image" do
      let(:processor) { "flux_image" }

      it "returns FluxPayloadStrategy initialized with parent_prompt" do
        strategy = selector.strategy

        expect(strategy)
          .to be_a(Generator::Media::Image::CreateTask::FluxPayloadStrategy)

        expect(strategy.prompt).to eq(parent_prompt)
      end
    end

    context "when processor is nano_banana_image" do
      let(:processor) { "nano_banana_image" }

      it "returns NanoBananaPayloadStrategy initialized with parent_prompt" do
        strategy = selector.strategy

        expect(strategy)
          .to be_a(Generator::Media::Image::CreateTask::NanoBananaPayloadStrategy)

        expect(strategy.prompt).to eq(parent_prompt)
      end
    end

    context "when processor is nano_banana_edit_image" do
      let(:processor) { "nano_banana_edit_image" }
      let(:command_request) { create(:command_edit_image_request, prompt: "edit this image") }
      let(:parent_request) do
        create(:user_picture_message, command_request:, parent_request: command_request)
      end
      let(:request) do
        create(:button_image_processing_request, parent_request:, command_request:, processor:)
      end

      it "initializes strategy with command request prompt" do
        strategy = selector.strategy

        expect(strategy)
          .to be_a(Generator::Media::Image::CreateTask::NanoBananaEditPayloadStrategy)
        expect(strategy.prompt).to eq("edit this image")
      end
    end

    context "when parent_request has no parent_prompt method" do
      let(:processor) { "flux_image" }
      let(:parent_request) { create(:command_prompt_to_image_request) }

      it "initializes strategy with nil prompt" do
        strategy = selector.strategy

        expect(strategy.prompt).to be_nil
      end
    end
  end
end
