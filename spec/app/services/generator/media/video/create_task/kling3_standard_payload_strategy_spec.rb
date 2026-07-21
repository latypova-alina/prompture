require "rails_helper"

describe Generator::Media::Video::CreateTask::Kling3StandardPayloadStrategy do
  subject(:strategy) { described_class.new(prompt, button_request:) }

  let(:prompt) { "Animate between frames" }
  let(:command_request) do
    create(
      :command_two_frame_to_video_request,
      start_image_url: "https://example.com/start.png",
      end_image_url: "https://example.com/end.png"
    )
  end
  let(:button_request) do
    create(
      :button_video_processing_request,
      processor: "kling_3_standard_image_to_video",
      command_request:
    )
  end

  it "builds the fal payload with both frame urls" do
    expect(strategy.payload).to eq(
      prompt: "Animate between frames",
      start_image_url: "https://example.com/start.png",
      end_image_url: "https://example.com/end.png",
      duration: "3",
      generate_audio: false,
      negative_prompt: "blur, distort, and low quality"
    )
  end

  it "uses the kling v3 standard endpoint" do
    expect(strategy.api_url)
      .to eq("https://queue.fal.run/fal-ai/kling-video/v3/standard/image-to-video")
  end
end
