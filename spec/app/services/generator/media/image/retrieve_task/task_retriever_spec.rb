# spec/services/generator/media/image/retrieve_task/task_retriever_spec.rb

require "rails_helper"

describe Generator::Media::Image::RetrieveTask::TaskRetriever do
  subject(:media_url) { described_class.new(task_id, processor).media_url }

  let(:task_id) { "123" }
  let(:processor) { "gemini_image" }

  let(:api_url_fetcher_instance) { double }
  let(:api_url) { "https://api.example.com/tasks" }

  let(:api_client_instance) { double }
  let(:api_response) { double }

  let(:extractor_instance) { double }
  let(:media_url_result) { "http://example.com/image.png" }

  before do
    allow(Generator::Media::Image::RetrieveTask::ApiUrlFetcher)
      .to receive(:new)
      .with(processor)
      .and_return(api_url_fetcher_instance)

    allow(api_url_fetcher_instance)
      .to receive(:api_url)
      .and_return(api_url)

    allow(Generator::Media::Image::RetrieveTask::ApiClient)
      .to receive(:new)
      .with(task_id, api_url)
      .and_return(api_client_instance)

    allow(api_client_instance)
      .to receive(:api_response)
      .and_return(api_response)

    allow(Generator::Media::Image::RetrieveTask::ImageExtractor)
      .to receive(:new)
      .with(api_response)
      .and_return(extractor_instance)

    allow(extractor_instance)
      .to receive(:media_url)
      .and_return(media_url_result)
  end

  describe "#media_url" do
    it "retrieves media url using api client and extractor" do
      expect(media_url).to eq(media_url_result)

      expect(Generator::Media::Image::RetrieveTask::ApiUrlFetcher)
        .to have_received(:new)
        .with(processor)

      expect(Generator::Media::Image::RetrieveTask::ApiClient)
        .to have_received(:new)
        .with(task_id, api_url)

      expect(Generator::Media::Image::RetrieveTask::ImageExtractor)
        .to have_received(:new)
        .with(api_response)
    end
  end
end
