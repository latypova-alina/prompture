require "rails_helper"

describe Generator::Media::Prompt::RetrieveTask::ApiUrlFetcher do
  subject(:api_url) { described_class.new(processor).api_url }

  let(:processor) { Generator::Processors::PROMPT_EXTENSION }

  describe "#api_url" do
    it "returns url for extend_prompt processor" do
      expect(api_url).to eq(described_class::API_URLS.fetch(processor))
    end
  end
end
