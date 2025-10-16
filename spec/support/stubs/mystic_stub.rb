require "rails_helper"

shared_context "stub create mystic task success request" do
  before do
    stub_request(:post, "https://api.freepik.com/v1/ai/mystic")
      .with(
        headers: {
          "Content-Type" => "application/json",
          "Accept" => "application/json"
        },
        body: {
          aspect_ratio: "social_story_9_16",
          model: "zen",
          filter_nsfw: false,
          resolution: "2k",
          prompt:
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

shared_context "stub retrieve mystic task success request" do
  before do
    stub_request(:get, "https://api.freepik.com/v1/ai/mystic/#{task_id}")
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

shared_context "stub mystic success request" do
  include_context "stub create mystic task success request"
  include_context "stub retrieve mystic task success request"
end

shared_context "stub create mystic task fail request" do
  before do
    stub_request(:post, "https://api.freepik.com/v1/ai/mystic")
      .with(
        headers: {
          "Content-Type" => "application/json",
          "Accept" => "application/json"
        },
        body: {
          aspect_ratio: "social_story_9_16",
          model: "zen",
          filter_nsfw: false,
          resolution: "2k",
          prompt: prompt
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

shared_context "stub retrieve mystic task fail request" do
  before do
    stub_request(:get, "https://api.freepik.com/v1/ai/mystic/#{task_id}")
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

shared_context "stub retrieve mystic task with FAILED status" do
  before do
    stub_request(:get, "https://api.freepik.com/v1/ai/mystic/#{task_id}")
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

shared_context "stub retrieve mystic task with IN_PROGRESS status" do
  before do
    stub_request(:get, "https://api.freepik.com/v1/ai/mystic/#{task_id}")
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
