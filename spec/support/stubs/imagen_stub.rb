require "rails_helper"

shared_context "stub create imagen task success request" do
  before do
    stub_request(:post, "https://api.freepik.com/v1/ai/text-to-image/imagen3")
      .with(
        headers: {
          "Content-Type" => "application/json",
          "Accept" => "application/json"
        },
        body: {
          webhook_url: "https://example.com/freepik/webhook?token=#{token}&button_request=imagen_image",
          prompt:,
          "aspect_ratio": "social_story_9_16",
          "styling": {
            "style": "3d"
          }
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

shared_context "stub retrieve imagen task success request" do
  before do
    stub_request(:get, "https://api.freepik.com/v1/ai/text-to-image/imagen3/#{task_id}")
      .to_return(
        status: 200,
        body: {
          "data": {
            "generated": [
              "https://ai-statics.freepik.com/completed_task_image.jpg"
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

shared_context "stub imagen success request" do
  include_context "stub create imagen task success request"
  include_context "stub retrieve imagen task success request"
end

shared_context "stub create imagen task fail request" do
  before do
    stub_request(:post, "https://api.freepik.com/v1/ai/text-to-image/imagen3")
      .with(
        headers: {
          "Content-Type" => "application/json",
          "Accept" => "application/json"
        },
        body: {
          webhook_url: "https://example.com/freepik/webhook?token=#{token}&button_request=imagen_image",
          prompt:,
          "aspect_ratio": "social_story_9_16",
          "styling": {
            "style": "3d"
          }
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

shared_context "stub retrieve imagen task fail request" do
  before do
    stub_request(:get, "https://api.freepik.com/v1/ai/text-to-image/imagen3/#{task_id}")
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

shared_context "stub retrieve imagen task with FAILED status" do
  before do
    stub_request(:get, "https://api.freepik.com/v1/ai/text-to-image/imagen3/#{task_id}")
      .to_return(
        status: 200,
        body: {
          "data": {
            "generated": [
              "https://ai-statics.freepik.com/completed_task_image.jpg"
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

shared_context "stub retrieve imagen task with IN_PROGRESS status" do
  before do
    stub_request(:get, "https://api.freepik.com/v1/ai/text-to-image/imagen3/#{task_id}")
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
