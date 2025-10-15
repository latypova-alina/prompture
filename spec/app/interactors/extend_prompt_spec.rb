require "rails_helper"

describe ExtendPrompt, type: :interactor do
  let(:prompt) { "cute white kitten goes to school" }
  let(:system_prompt) do
    "You are a prompt enhancer. Take the user’s short idea and rewrite it into a detailed, "\
    "vivid English prompt suitable for an image generator. Focus on subject, setting, mood, "\
    "and visual details, in one or two sentences."
  end
  let(:chat_gpt_client) { instance_double(Clients::ChatGpt::PromptGenerator, response_body: "Extended prompt text") }

  subject(:interactor) { described_class.call(prompt:) }

  describe "#call" do
    before do
      allow(Clients::ChatGpt::PromptGenerator).to receive(:new)
        .with(
          [
            { "role" => "system", "content" => system_prompt },
            { "role" => "user", "content" => prompt }
          ]
        )
        .and_return(chat_gpt_client)
    end

    it "sets context.extended_prompt to the client response" do
      expect(interactor).to be_a_success
      expect(interactor.extended_prompt).to eq("Extended prompt text")
    end

    context "when ChatGPT client raises ResponseError" do
      before do
        allow(Clients::ChatGpt::PromptGenerator).to receive(:new)
          .and_raise(ChatGpt::ResponseError)
      end

      it "raises ChatGpt::ResponseError" do
        expect { interactor.extended_prompt }.to raise_error(ChatGpt::ResponseError)
      end
    end
  end
end
