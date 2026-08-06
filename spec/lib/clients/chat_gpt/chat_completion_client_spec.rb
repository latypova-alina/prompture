require "rails_helper"

describe Clients::ChatGpt::ChatCompletionClient do
  subject { described_class.new(messages).response_body }

  let(:prompt) { "cute white kitten" }

  let(:system_prompt) do
    File.read(Rails.root.join("config/prompts/prompt_generator_system_content.txt")).strip
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
