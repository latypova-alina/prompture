require "rails_helper"

shared_context "stub create kling_2_1_pro task success request" do
  before do
    stub_request(:post, "https://queue.fal.run/fal-ai/kling-video/v2.1/pro/image-to-video")
      .with(query: hash_including("fal_webhook" => /request_id_token=.*processor=kling_2_1_pro_image_to_video/))
      .with(
        headers: {
          "Content-Type" => "application/json",
          "Accept" => "application/json",
          "Authorization" => "Key FAL_API_KEY"
        },
        body: {
          prompt:,
          duration: 5,
          image_url:
        }.to_json
      )
      .to_return(
        status: 200,
        body: {
          request_id: task_id
        }.to_json,
        headers: { "Content-Type" => "application/json" }
      )
  end
end

shared_context "stub create kling_2_1_pro task fail request" do
  before do
    stub_request(:post, "https://queue.fal.run/fal-ai/kling-video/v2.1/pro/image-to-video")
      .with(query: hash_including("fal_webhook" => /request_id_token=.*processor=kling_2_1_pro_image_to_video/))
      .with(
        headers: {
          "Content-Type" => "application/json",
          "Accept" => "application/json",
          "Authorization" => "Key FAL_API_KEY"
        },
        body: {
          prompt:,
          duration: 5,
          image_url:
        }.to_json
      )
      .to_return(
        status: 400,
        body: {
          detail: "Invalid prompt or bad request"
        }.to_json,
        headers: { "Content-Type" => "application/json" }
      )
  end
end
