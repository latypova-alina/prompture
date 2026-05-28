require "rails_helper"

describe Generator::Media::Image::CreateTask::PayloadComposer do
  subject(:composer) { described_class.new(request, strategy) }

  let(:request) do
    instance_double(
      ButtonImageProcessingRequest,
      id: 42,
      processor: "flux_image"
    )
  end

  let(:strategy_payload) { { prompt: "hello", image_size: "portrait_16_9" } }

  let(:strategy) do
    instance_double(
      Generator::Media::Image::CreateTask::FluxPayloadStrategy,
      payload: strategy_payload
    )
  end

  let(:webhook_url) { "https://example.com/api/fal/webhook" }

  before do
    allow(Generator::Media::WebhookUrlBuilder)
      .to receive(:new)
      .with(processor: "flux_image", button_request_id: 42)
      .and_return(double(webhook_url: webhook_url))
  end

  describe "#final_payload" do
    it "returns strategy payload without webhook" do
      expect(composer.final_payload).to eq(strategy_payload)
    end
  end

  describe "#webhook_url" do
    it "returns webhook url from WebhookUrlBuilder" do
      expect(composer.webhook_url).to eq(webhook_url)
    end
  end
end
