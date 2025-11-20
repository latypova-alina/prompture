require "rails_helper"

shared_context "stub create kling task success request" do
  before do
    stub_request(:post, "https://api.freepik.com/v1/ai/image-to-video/kling-v2-1-pro")
      .with(
        headers: {
          "Content-Type" => "application/json",
          "Accept" => "application/json"
        },
        body: {
          webhook_url: "https://example.com/freepik/webhook?token=#{token}&button_request=kling_2_1_pro_image_to_video",
          prompt:,
          image: image_url,
          duration: "5",
          cfg_scale: "0.9"
        }.to_json
      )
      .to_return(
        status: 200,
        body: {
          data: {
            task_id:
          }
        }.to_json,
        headers: { "Content-Type" => "application/json" }
      )
  end
end

shared_context "stub retrieve kling task success request" do
  before do
    stub_request(:get, "https://api.freepik.com/v1/ai/image-to-video/kling-v2-1/#{task_id}")
      .to_return(
        status: 200,
        body: {
          "data": {
            "generated": [
              "https://ai-statics.freepik.com/completed_task_video.mp4"
            ],
            "task_id": task_id,
            "status": "COMPLETED",
            "has_nsfw": [
              false
            ]
          }
        }.to_json,
        headers: { "Content-Type" => "application/json" }
      )
  end
end

shared_context "stub kling success request" do
  include_context "stub create kling task success request"
  include_context "stub retrieve kling task success request"
end

shared_context "stub create kling task fail request" do
  before do
    stub_request(:post, "https://api.freepik.com/v1/ai/image-to-video/kling-v2-1-pro")
      .with(
        headers: {
          "Content-Type" => "application/json",
          "Accept" => "application/json"
        },
        body: {
          webhook_url: "https://example.com/freepik/webhook?token=#{token}&button_request=kling_2_1_pro_image_to_video",
          prompt:,
          image: image_url,
          duration: "5",
          cfg_scale: "0.9"
        }.to_json
      )
      .to_return(
        status: 400,
        body: {
          error: {
            message: "Invalid prompt or bad request",
            code: "bad_request"
          }
        }.to_json,
        headers: { "Content-Type" => "application/json" }
      )
  end
end

shared_context "stub retrieve kling task fail request" do
  before do
    stub_request(:get, "https://api.freepik.com/v1/ai/image-to-video/kling-v2-1/#{task_id}")
      .to_return(
        status: 500,
        body: {
          error: {
            message: "Internal server error",
            code: "internal_error"
          }
        }.to_json,
        headers: { "Content-Type" => "application/json" }
      )
  end
end

shared_context "stub retrieve kling task with FAILED status" do
  before do
    stub_request(:get, "https://api.freepik.com/v1/ai/image-to-video/kling-v2-1/#{task_id}")
      .to_return(
        status: 200,
        body: {
          "data": {
            "generated": [
              "https://ai-statics.freepik.com/completed_task_video.mp4"
            ],
            "task_id": task_id,
            "status": "FAILED",
            "has_nsfw": [
              false
            ]
          }
        }.to_json,
        headers: { "Content-Type" => "application/json" }
      )
  end
end

shared_context "stub retrieve kling task with IN_PROGRESS status" do
  before do
    stub_request(:get, "https://api.freepik.com/v1/ai/image-to-video/kling-v2-1/#{task_id}")
      .to_return(
        status: 200,
        body: {
          "data": {
            "task_id": task_id,
            "status": "IN_PROGRESS",
            "has_nsfw": [
              false
            ]
          }
        }.to_json,
        headers: { "Content-Type" => "application/json" }
      )
  end
end
