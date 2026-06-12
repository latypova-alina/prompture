require "rails_helper"

describe Generator::Media::Video::CreateTask::PayloadEnhancers::CartoonShortsScript do
  subject(:enhanced_payload) { described_class.new(request:, payload:).enhance }

  let(:payload) { { prompt: "hello", aspect_ratio: "9:16", duration: 6 } }
  let(:command_request) do
    create(:command_prompt_to_video_request, category: ContentCategory::CARTOON_SHORTS_SCRIPT)
  end
  let(:request) do
    create(
      :button_video_processing_request,
      processor: "veo3_1_lite_image_to_video",
      command_request:
    )
  end

  it "sets aspect ratio to 9:16 and duration to 8 seconds" do
    expect(enhanced_payload).to eq(prompt: "hello", aspect_ratio: "9:16", duration: 8)
  end

  describe ".applies_to?" do
    it "returns true for cartoon shorts script veo requests" do
      expect(described_class.applies_to?(request)).to be(true)
    end

    it "returns false for cartoon script requests" do
      command_request = create(:command_prompt_to_video_request, category: ContentCategory::CARTOON_SCRIPT)
      request = create(
        :button_video_processing_request,
        processor: "veo3_1_lite_image_to_video",
        command_request:
      )

      expect(described_class.applies_to?(request)).to be(false)
    end
  end
end
