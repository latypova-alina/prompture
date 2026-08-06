require "rails_helper"

shared_context "stub chat_gpt success request" do
  before do
    stub_request(:post, "https://api.openai.com/v1/chat/completions")
      .with(
        body: hash_including(
          model: "gpt-4o",
          messages: [
            {
              "role" => "system",
              "content" => File.read(Rails.root.join("config/prompts/prompt_generator_system_content.txt")).strip
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
