require "rails_helper"

describe Generator::Media::Prompt::RetrieveTask::TaskRetriever do
  subject(:extended_prompt) { described_class.new(task_id, processor).media_url }

  let(:task_id) { "123" }
  let(:processor) { Generator::Processors::PROMPT_EXTENSION }

  let(:api_url_fetcher_instance) { double }
  let(:api_url) { "https://api.example.com/tasks" }

  let(:api_client_instance) { double }
  let(:api_response) { double }

  let(:extractor_instance) { double }
  let(:extended_prompt_result) { "extended prompt text" }

  before do
    allow(Generator::Media::Prompt::RetrieveTask::ApiUrlFetcher)
      .to receive(:new)
      .with(processor)
      .and_return(api_url_fetcher_instance)

    allow(api_url_fetcher_instance)
      .to receive(:api_url)
      .and_return(api_url)

    allow(Generator::Media::Prompt::RetrieveTask::ApiClient)
      .to receive(:new)
      .with(task_id, api_url)
      .and_return(api_client_instance)

    allow(api_client_instance)
      .to receive(:api_response)
      .and_return(api_response)

    allow(Generator::Media::Prompt::RetrieveTask::PromptExtractor)
      .to receive(:new)
      .with(api_response)
      .and_return(extractor_instance)

    allow(extractor_instance)
      .to receive(:media_url)
      .and_return(extended_prompt_result)
  end

  describe "#media_url" do
    it "retrieves prompt using api client and extractor" do
      expect(extended_prompt).to eq(extended_prompt_result)

      expect(Generator::Media::Prompt::RetrieveTask::ApiUrlFetcher)
        .to have_received(:new)
        .with(processor)

      expect(Generator::Media::Prompt::RetrieveTask::ApiClient)
        .to have_received(:new)
        .with(task_id, api_url)

      expect(Generator::Media::Prompt::RetrieveTask::PromptExtractor)
        .to have_received(:new)
        .with(api_response)
    end
  end
end
