require "rails_helper"

describe Generator::Media::Video::CreateTask::PayloadEnhancers::CartoonScript do
  subject(:enhanced_payload) { described_class.new(request:, payload:).enhance }

  let(:payload) { { prompt: "hello", aspect_ratio: "9:16" } }
  let(:command_request) do
    create(:command_prompt_to_video_request, category: ContentCategory::CARTOON_SCRIPT)
  end
  let(:request) do
    create(
      :button_video_processing_request,
      processor: "veo3_1_lite_image_to_video",
      command_request:
    )
  end

  it "sets aspect ratio to 16:9 and duration to 8 seconds" do
    expect(enhanced_payload).to eq(prompt: "hello", aspect_ratio: "16:9", duration: 8)
  end

  describe ".applies_to?" do
    it "returns true for cartoon script veo requests" do
      expect(described_class.applies_to?(request)).to be(true)
    end

    it "returns false for non-cartoon script requests" do
      request = create(:button_video_processing_request, processor: "veo3_1_lite_image_to_video")

      expect(described_class.applies_to?(request)).to be(false)
    end
  end
end
