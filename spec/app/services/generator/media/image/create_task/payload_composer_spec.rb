# spec/services/generator/media/image/create_task/payload_composer_spec.rb

require "rails_helper"

describe Generator::Media::Image::CreateTask::PayloadComposer do
  subject(:composer) { described_class.new(request, strategy) }

  let(:request) do
    instance_double(
      ButtonImageProcessingRequest,
      id: 42,
      processor: "mystic_image"
    )
  end

  let(:strategy_payload) { { foo: "bar" } }

  let(:strategy) do
    instance_double(
      Generator::Media::Image::CreateTask::MysticPayloadStrategy,
      payload: strategy_payload
    )
  end

  let(:webhook_url) { "https://example.com/webhook" }

  before do
    allow(Generator::Media::WebhookUrlBuilder)
      .to receive(:new)
      .with(processor: "mystic_image", button_request_id: 42)
      .and_return(double(webhook_url: webhook_url))
  end

  describe "#final_payload" do
    it "merges strategy payload with webhook_url" do
      expect(composer.final_payload).to eq(
        foo: "bar",
        webhook_url:
      )
    end

    it "does not override strategy keys (reverse_merge behavior)" do
      overlapping_strategy = double(payload: { webhook_url: "custom", foo: "bar" })

      composer_with_overlap = described_class.new(request, overlapping_strategy)

      expect(composer_with_overlap.final_payload[:webhook_url]).to eq("custom")
    end
  end
end
