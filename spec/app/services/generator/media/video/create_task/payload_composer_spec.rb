require "rails_helper"

describe Generator::Media::Video::CreateTask::PayloadComposer do
  subject(:composer) { described_class.new(request, strategy) }

  let(:request) { create(:button_video_processing_request, image_url:) }
  let(:image_url) { "http://example.com/image.png" }
  let(:processor) { "kling_2_1_pro_image_to_video" }

  let(:strategy) { instance_double("Strategy", payload: strategy_payload) }
  let(:strategy_payload) { { prompt: "hello" } }

  let(:webhook_url_builder_instance) { double }
  let(:webhook_url) { "http://example.com/webhook" }

  before do
    allow(Generator::Media::WebhookUrlBuilder)
      .to receive(:new)
      .with(processor:, button_request_id: request.id)
      .and_return(webhook_url_builder_instance)

    allow(webhook_url_builder_instance)
      .to receive(:webhook_url)
      .and_return(webhook_url)
  end

  describe "#final_payload" do
    it "merges strategy payload with webhook_url and image_url" do
      expect(composer.final_payload).to eq(
        prompt: "hello",
        webhook_url:,
        image: image_url
      )
    end
  end
end
