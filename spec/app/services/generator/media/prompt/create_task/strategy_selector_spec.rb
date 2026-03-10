require "rails_helper"

describe Generator::Media::Prompt::CreateTask::StrategySelector do
  subject(:strategy) { described_class.new(request).strategy }

  let(:parent_prompt) { "make it more cinematic" }
  let(:parent_request) { instance_double("CommandRequest", parent_prompt: parent_prompt) }
  let(:request) do
    instance_double(
      ButtonExtendPromptRequest,
      processor: Generator::Processors::PROMPT_EXTENSION,
      parent_request: parent_request
    )
  end

  describe "#strategy" do
    it "returns ExtendPromptPayloadStrategy initialized with parent prompt" do
      expect(strategy).to be_a(Generator::Media::Prompt::CreateTask::ExtendPromptPayloadStrategy)
      expect(strategy.prompt).to eq(parent_prompt)
    end
  end
end
