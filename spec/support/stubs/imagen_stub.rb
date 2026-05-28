require "rails_helper"

shared_context "stub create imagen task success request" do
  before do
    stub_request(:post, "https://queue.fal.run/fal-ai/imagen4/preview/fast")
      .with(query: hash_including("fal_webhook" => /request_id_token=.*processor=imagen_image/))
      .with(
        headers: {
          "Content-Type" => "application/json",
          "Accept" => "application/json",
          "Authorization" => "Key FAL_API_KEY"
        },
        body: {
          prompt:,
          aspect_ratio: "9:16"
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

shared_context "stub create imagen task fail request" do
  before do
    stub_request(:post, "https://queue.fal.run/fal-ai/imagen4/preview/fast")
      .with(query: hash_including("fal_webhook" => /processor=imagen_image/))
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
