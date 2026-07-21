require "rails_helper"

describe Generator::Media::Video::CreateTask::PayloadComposer do
  subject(:composer) { described_class.new(request, strategy) }

  let(:request) { create(:button_video_processing_request, image_url:) }
  let(:image_url) { "http://example.com/image.png" }
  let(:processor) { "kling_2_1_pro_image_to_video" }

  let(:strategy) { instance_double("Strategy", payload: strategy_payload) }
  let(:strategy_payload) { { prompt: "hello", image_url: } }

  describe "#final_payload" do
    it "returns the strategy payload" do
      expect(composer.final_payload).to eq(
        prompt: "hello",
        image_url:
      )
    end
  end

  context "when processor is veo3_1_lite for cartoon_script" do
    let(:processor) { "veo3_1_lite_image_to_video" }
    let(:command_request) do
      create(:command_prompt_to_video_request, category: ContentCategory::BLOOMY_CARTOON_SCRIPT)
    end
    let(:request) do
      create(
        :button_video_processing_request,
        image_url:,
        processor:,
        command_request:
      )
    end
    let(:strategy_payload) do
      {
        prompt: "hello",
        image_url:,
        aspect_ratio: "auto",
        duration: 6,
        generate_audio: false
      }
    end

    it "overrides aspect ratio to 16:9 and duration to 8 seconds" do
      expect(composer.final_payload).to eq(
        prompt: "hello",
        image_url:,
        aspect_ratio: "16:9",
        duration: 8,
        generate_audio: false
      )
    end
  end

  context "when processor is veo3_1_lite for cartoon_shorts_script" do
    let(:processor) { "veo3_1_lite_image_to_video" }
    let(:command_request) do
      create(:command_prompt_to_video_request, category: ContentCategory::CARTOON_BLOOMY_SHORTS_SCRIPT)
    end
    let(:request) do
      create(
        :button_video_processing_request,
        image_url:,
        processor:,
        command_request:
      )
    end
    let(:strategy_payload) do
      {
        prompt: "hello",
        image_url:,
        aspect_ratio: "auto",
        duration: 6,
        generate_audio: false
      }
    end

    it "keeps aspect ratio at 9:16 and sets duration to 8 seconds" do
      expect(composer.final_payload).to eq(
        prompt: "hello",
        image_url:,
        aspect_ratio: "9:16",
        duration: 8,
        generate_audio: false
      )
    end
  end
end
