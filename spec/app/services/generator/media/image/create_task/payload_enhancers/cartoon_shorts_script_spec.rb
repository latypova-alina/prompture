require "rails_helper"

describe Generator::Media::Image::CreateTask::PayloadEnhancers::CartoonShortsScript do
  subject(:enhanced_payload) { described_class.new(request:, payload:).enhance }

  let(:payload) { { prompt: "hello" } }
  let(:parent_request) do
    instance_double(UserImageUrlMessage, resolved_image_url: "https://internal.example/bloomy.png")
  end
  let(:command_request) do
    instance_double(CommandEditImageRequest, cartoon_shorts_script?: true)
  end
  let(:request) do
    instance_double(
      ButtonImageProcessingRequest,
      processor:,
      parent_request:,
      command_request:
    )
  end

  context "when processor is nano_banana_edit_image" do
    let(:processor) { "nano_banana_edit_image" }

    it "sets aspect ratio to 9:16" do
      expect(enhanced_payload).to eq(prompt: "hello", aspect_ratio: "9:16")
    end
  end

  context "when processor is nano_banana_image" do
    let(:processor) { "nano_banana_image" }

    it "sets aspect ratio to 9:16 and includes reference image" do
      expect(enhanced_payload).to eq(
        prompt: "hello",
        aspect_ratio: "9:16",
        image_urls: ["https://internal.example/bloomy.png"]
      )
    end
  end
end
