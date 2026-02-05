require "rails_helper"

describe Clients::ChatGpt::ChatCompletionClient do
  subject { described_class.new(messages).response_body }

  let(:prompt) { "cute white kitten" }

  let(:system_prompt) do
    "You are a prompt enhancer. Take the user’s short idea and rewrite it into a detailed, "\
                  "vivid English prompt suitable for an image generator. Focus on subject, setting, mood, and visual "\
                  "details, in one or two sentences."
  end

  let(:messages) do
    [
      { "role" => "system", "content" => system_prompt },
      { "role" => "user", "content" => prompt }
    ]
  end

  context "when ChatGPT request succeeds" do
    include_context "stub chat_gpt success request"

    it "returns response content from ChatGPT" do
      expect(subject).to eq("simulated GPT text")
    end
  end

  context "when ChatGPT request fails" do
    include_context "stub chat_gpt error request"

    it "raises ChatGpt::ResponseError" do
      expect do
        subject
      end.to raise_error(ChatGpt::ResponseError)
    end
  end
end
