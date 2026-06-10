require "rails_helper"

describe Generator::Media::Image::CreateTask::PayloadComposer do
  subject(:composer) { described_class.new(request, strategy) }

  let(:strategy_payload) { { prompt: "hello" } }
  let(:strategy) do
    instance_double(
      Generator::Media::Image::CreateTask::NanoBananaEditPayloadStrategy,
      payload: strategy_payload
    )
  end

  before do
    allow(Generator::Media::WebhookUrlBuilder)
      .to receive(:new)
      .with(processor:, button_request_id: 42)
      .and_return(double(webhook_url: "https://example.com/api/fal/webhook"))
  end

  context "when processor is nano_banana_edit_image" do
    let(:processor) { "nano_banana_edit_image" }
    let(:parent_request) do
      instance_double(UserPictureMessage, resolved_image_url: "https://internal.example/source.png")
    end
    let(:request) do
      instance_double(
        ButtonImageProcessingRequest,
        id: 42,
        processor:,
        parent_request:,
        command_request: nil
      )
    end

    it "includes image_urls in the payload" do
      expect(composer.final_payload).to eq(
        prompt: "hello",
        image_urls: ["https://internal.example/source.png"]
      )
    end
  end

  context "when processor is nano_banana_edit_image for cartoon_script" do
    let(:processor) { "nano_banana_edit_image" }
    let(:parent_request) do
      instance_double(UserImageUrlMessage, resolved_image_url: "https://internal.example/bloomy.png")
    end
    let(:command_request) do
      instance_double(CommandEditImageRequest, category: ContentCategory::CARTOON_SCRIPT)
    end
    let(:request) do
      instance_double(
        ButtonImageProcessingRequest,
        id: 42,
        processor:,
        parent_request:,
        command_request:
      )
    end

    it "includes source image from parent and 16:9 aspect ratio" do
      expect(composer.final_payload).to eq(
        prompt: "hello",
        aspect_ratio: "16:9",
        image_urls: ["https://internal.example/bloomy.png"]
      )
    end
  end

  context "when processor is nano_banana_image for cartoon_script" do
    let(:processor) { "nano_banana_image" }
    let(:parent_request) do
      instance_double(UserImageUrlMessage, resolved_image_url: "https://example.com/bloomy.png")
    end
    let(:command_request) do
      instance_double(CommandEditImageRequest, category: ContentCategory::CARTOON_SCRIPT)
    end
    let(:request) do
      instance_double(
        ButtonImageProcessingRequest,
        id: 42,
        processor:,
        parent_request:,
        command_request:
      )
    end
    let(:strategy_payload) { { prompt: "hello", aspect_ratio: "9:16" } }
    let(:strategy) do
      instance_double(
        Generator::Media::Image::CreateTask::NanoBananaPayloadStrategy,
        payload: strategy_payload
      )
    end

    it "includes character reference image and 16:9 aspect ratio" do
      expect(composer.final_payload).to eq(
        prompt: "hello",
        aspect_ratio: "16:9",
        image_urls: ["https://example.com/bloomy.png"]
      )
    end
  end

  context "when processor is flux_image" do
    let(:processor) { "flux_image" }
    let(:request) do
      instance_double(
        ButtonImageProcessingRequest,
        id: 42,
        processor:,
        command_request: nil
      )
    end

    it "returns strategy payload without image_urls" do
      expect(composer.final_payload).to eq(strategy_payload)
    end
  end
end
