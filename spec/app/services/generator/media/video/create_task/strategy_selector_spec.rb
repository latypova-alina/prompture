require "rails_helper"

describe Generator::Media::Video::CreateTask::StrategySelector do
  subject(:strategy) { described_class.new(request).strategy }

  let(:parent_prompt) { "little kitten" }

  let(:parent_request) { create(:prompt_message, prompt: parent_prompt) }

  let(:request) { create(:button_video_processing_request, parent_request:) }

  describe "#strategy" do
    it "returns KlingPayloadStrategy initialized with parent prompt" do
      expect(strategy)
        .to be_a(Generator::Media::Video::CreateTask::KlingPayloadStrategy)

      expect(strategy.prompt).to eq(parent_prompt)
    end
  end

  context "when parent_request has no parent_prompt method" do
    let(:parent_request) { create(:command_prompt_to_video_request) }

    it "initializes strategy with nil prompt" do
      expect(strategy.prompt).to be_nil
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
