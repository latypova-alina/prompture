require "rails_helper"

describe Admin::FalDashboardUrl do
  subject { described_class.new(button_request).url }

  let(:fal_request_id) { "01a08b93-d63f-7c80-809b-d8e11ec1a0bd" }

  {
    [:button_image_processing_request, "flux_image"] => "fal-ai/flux-2-pro",
    [:button_image_processing_request, "nano_banana_image"] => "fal-ai/nano-banana-2",
    [:button_image_processing_request, "nano_banana_edit_image"] => "fal-ai/nano-banana-2/edit",
    [:button_video_processing_request, "veo3_1_lite_image_to_video"] => "fal-ai/veo3.1/lite/image-to-video",
    [:button_video_processing_request, "kling_2_1_pro_image_to_video"] => "fal-ai/kling-video/v2.1/pro/image-to-video",
    [:button_video_processing_request, "kling_3_standard_image_to_video"] =>
      "fal-ai/kling-video/v3/standard/image-to-video",
    [:button_video_processing_request, "hailuo_02_standard_image_to_video"] =>
      "fal-ai/minimax/hailuo-02/standard/image-to-video",
    [:button_audio_processing_request, "elevenlabs_v3_audio"] => "fal-ai/elevenlabs/tts/eleven-v3"
  }.each do |(factory, processor), endpoint|
    context "when the processor is #{processor}" do
      let(:button_request) { create(factory, processor:, fal_request_id:) }

      it { is_expected.to eq("https://fal.ai/models/#{endpoint}/requests/#{fal_request_id}") }
    end
  end

  context "when there is no fal_request_id" do
    let(:button_request) { create(:button_image_processing_request, fal_request_id: nil) }

    it { is_expected.to be_nil }
  end

  context "when the request doesn't go through fal" do
    let(:button_request) { create(:button_merge_audio_video_processing_request) }

    it { is_expected.to be_nil }
  end

  context "when it is an extend prompt request" do
    let(:button_request) { create(:button_extend_prompt_request) }

    it { is_expected.to be_nil }
  end
end
