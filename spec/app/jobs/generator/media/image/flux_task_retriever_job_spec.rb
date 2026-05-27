require "rails_helper"

describe Generator::Media::Image::FluxTaskRetrieverJob do
  subject(:perform_job) { described_class.new.perform(generated_media_url, button_request_id, processor) }

  let(:generated_media_url) { "https://fal.media/source.png" }
  let(:button_request_id) { 42 }
  let(:processor) { "flux_image" }
  let(:retriever_instance) { instance_double(Generator::Media::Image::RetrieveTask::FluxImageRetriever) }

  before do
    allow(Generator::Media::Image::RetrieveTask::FluxImageRetriever)
      .to receive(:new)
      .with(media_url: generated_media_url, button_request_id:, processor:)
      .and_return(retriever_instance)
  end

  context "when retrieval succeeds" do
    let(:final_media_url) { "https://prompture.s3.eu-central-1.amazonaws.com/image.png" }

    before do
      allow(retriever_instance).to receive(:media_url).and_return(final_media_url)
      allow(Generator::Media::Image::SuccessNotifierJob).to receive(:perform_async)
    end

    it "enqueues SuccessNotifierJob with final media url" do
      perform_job

      expect(Generator::Media::Image::SuccessNotifierJob)
        .to have_received(:perform_async)
        .with(final_media_url, button_request_id)
    end
  end

  context "when retriever raises Freepik::ResponseError" do
    before do
      allow(retriever_instance).to receive(:media_url).and_raise(Freepik::ResponseError)
      allow(Generator::Media::Image::ErrorNotifierJob).to receive(:perform_async)
    end

    it "enqueues ErrorNotifierJob" do
      perform_job

      expect(Generator::Media::Image::ErrorNotifierJob)
        .to have_received(:perform_async)
        .with(button_request_id)
    end
  end
end
