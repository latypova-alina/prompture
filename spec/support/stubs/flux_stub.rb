require "rails_helper"

shared_context "stub create flux task success request" do
  before do
    stub_request(:post, "https://queue.fal.run/fal-ai/flux-2-pro")
      .with(query: hash_including("fal_webhook" => /request_id_token=.*processor=flux_image/))
      .with(
        headers: {
          "Content-Type" => "application/json",
          "Accept" => "application/json",
          "Authorization" => "Key FAL_API_KEY"
        },
        body: {
          prompt:
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
