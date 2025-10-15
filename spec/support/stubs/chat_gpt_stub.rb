require "rails_helper"

shared_context "stub chat_gpt success request" do
  before do
    stub_request(:post, "https://api.openai.com/v1/chat/completions")
      .with(
        body: hash_including(
          model: "gpt-4o-mini",
          messages: [
            {
              "role" => "system",
              "content" => "You are a prompt enhancer. Take the user’s short idea and rewrite it into a detailed, "\
              "vivid English prompt suitable for an image generator. Focus on subject, setting, mood, and visual "\
              "details, in one or two sentences."
            },
            {
              "role" => "user",
              "content" => prompt
            }
          ]
        )
      )
      .to_return(
        status: 200,
        body: {
          choices: [
            { message: { content: "simulated GPT text" } }
          ]
        }.to_json,
        headers: { "Content-Type" => "application/json" }
      )
  end
end

shared_context "stub chat_gpt error request" do
  before do
    stub_request(:post, "https://api.openai.com/v1/chat/completions")
      .to_return(
        status: 500,
        body: {
          error: {
            message: "Internal Server Error",
            type: "server_error",
            code: "internal_error"
          }
        }.to_json,
        headers: { "Content-Type" => "application/json" }
      )
  end
end
