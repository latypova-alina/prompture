require "rails_helper"

describe Generator::Media::Prompt::CreateTask::StrategySelector do
  subject(:strategy) { described_class.new(request).strategy }

  let(:parent_prompt) { "make it more cinematic" }
  let(:prompt_messsage) { create(:prompt_message, prompt: parent_prompt) }
  let(:request) { create(:button_extend_prompt_request, parent_request: prompt_messsage) }

  describe "#strategy" do
    it "returns ExtendPromptPayloadStrategy initialized with parent prompt" do
      expect(strategy).to be_a(Generator::Media::Prompt::CreateTask::ExtendPromptPayloadStrategy)
      expect(strategy.prompt).to eq(parent_prompt)
    end
  end
end
