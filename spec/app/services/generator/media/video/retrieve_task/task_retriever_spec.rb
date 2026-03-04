require "rails_helper"

describe Generator::Media::Video::RetrieveTask::TaskRetriever do
  subject(:media_url) { described_class.new(task_id, processor).media_url }

  let(:task_id) { "123" }
  let(:processor) { "kling_2_1_pro_image_to_video" }

  let(:api_url_fetcher_instance) { double }
  let(:api_url) { "https://api.example.com/tasks" }

  let(:api_client_instance) { double }
  let(:api_response) { double }

  let(:extractor_instance) { double }
  let(:media_url_result) { "http://example.com/video.mp4" }

  before do
    allow(Generator::Media::Video::RetrieveTask::ApiUrlFetcher)
      .to receive(:new)
      .with(processor)
      .and_return(api_url_fetcher_instance)

    allow(api_url_fetcher_instance)
      .to receive(:api_url)
      .and_return(api_url)

    allow(Generator::Media::Video::RetrieveTask::ApiClient)
      .to receive(:new)
      .with(task_id, api_url)
      .and_return(api_client_instance)

    allow(api_client_instance)
      .to receive(:api_response)
      .and_return(api_response)

    allow(Generator::Media::Video::RetrieveTask::VideoExtractor)
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

      expect(Generator::Media::Video::RetrieveTask::ApiUrlFetcher)
        .to have_received(:new)
        .with(processor)

      expect(Generator::Media::Video::RetrieveTask::ApiClient)
        .to have_received(:new)
        .with(task_id, api_url)

      expect(Generator::Media::Video::RetrieveTask::VideoExtractor)
        .to have_received(:new)
        .with(api_response)
    end
  end
end
