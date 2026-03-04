require "rails_helper"

describe Generator::PromptExtender do
  subject { described_class.new(raw_prompt).extended_prompt }

  let(:raw_prompt) { "cute white kitten" }
  let(:response_body) { "An ultra detailed prompt about a cute white kitten" }

  let(:system_prompt) do
    [
      "You are a prompt enhancer.",
      "Take the user’s short idea and rewrite it into a detailed, vivid English prompt suitable " \
      "for an image generator.",
      "Focus on subject, setting, mood, and visual details, in one or two sentences."
    ].join(" ")
  end

  let(:messages) do
    [
      { "role" => "system", "content" => system_prompt },
      { "role" => "user", "content" => raw_prompt }
    ]
  end

  let(:chat_gpt_client) do
    instance_double(
      Clients::ChatGpt::ChatCompletionClient,
      response_body:
    )
  end

  before do
    allow(Clients::ChatGpt::ChatCompletionClient)
      .to receive(:new)
      .with(messages)
      .and_return(chat_gpt_client)
  end

  it "returns extended prompt from ChatGPT client" do
    expect(subject).to eq(response_body)

    expect(Clients::ChatGpt::ChatCompletionClient)
      .to have_received(:new)
      .with(messages)
  end
end
