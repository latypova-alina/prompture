require "rails_helper"

shared_context "stub create gemini task success request" do
  before do
    stub_request(:post, "https://api.freepik.com/v1/ai/gemini-2-5-flash-image-preview")
      .with(
        headers: {
          "Content-Type" => "application/json",
          "Accept" => "application/json"
        },
        body: {
          webhook_url: "https://example.com/freepik/webhook?token=#{token}&button_request=gemini_image",
          prompt: "#{prompt}\nThe same ratio as reference image.",
          reference_images: ["https://prompture.s3.eu-central-1.amazonaws.com/vertical.jpg"]
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

shared_context "stub retrieve gemini task success request" do
  before do
    stub_request(:get, "https://api.freepik.com/v1/ai/gemini-2-5-flash-image-preview/#{task_id}")
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

shared_context "stub gemini success request" do
  include_context "stub create gemini task success request"
  include_context "stub retrieve gemini task success request"
end

shared_context "stub create gemini task fail request" do
  before do
    stub_request(:post, "https://api.freepik.com/v1/ai/gemini-2-5-flash-image-preview")
      .with(
        headers: {
          "Content-Type" => "application/json",
          "Accept" => "application/json"
        },
        body: {
          webhook_url: "https://example.com/freepik/webhook?token=#{token}&button_request=gemini_image",
          prompt: "#{prompt}\nThe same ratio as reference image.",
          reference_images: ["https://prompture.s3.eu-central-1.amazonaws.com/vertical.jpg"]
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

shared_context "stub retrieve gemini task fail request" do
  before do
    stub_request(:get, "https://api.freepik.com/v1/ai/gemini-2-5-flash-image-preview/#{task_id}")
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

shared_context "stub retrieve gemini task with FAILED status" do
  before do
    stub_request(:get, "https://api.freepik.com/v1/ai/gemini-2-5-flash-image-preview/#{task_id}")
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

shared_context "stub retrieve gemini task with IN_PROGRESS status" do
  before do
    stub_request(:get, "https://api.freepik.com/v1/ai/gemini-2-5-flash-image-preview/#{task_id}")
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
