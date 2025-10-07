require "rails_helper"

describe Clients::ChatGpt::PromptGenerator do
  let(:system_prompt) do
    "You are a prompt enhancer. Take the user’s short idea and rewrite it into a detailed, vivid English prompt suitable for an image generator. Focus on subject, setting, mood, and visual details, in one or two sentences."
  end
  let(:user_prompt) { "Little kitten goes to school" }
  let(:messages) do
    [
      { "role" => "system", "content" => system_prompt },
      { "role" => "user", "content" => user_prompt }
    ]
  end
  let(:prompt_generator) { described_class.new(messages) }
  let(:expected_response) do
    "A curious little kitten, with soft gray fur and bright blue eyes, "\
    "walks hesitantly towards a charming red-brick schoolhouse surrounded by "\
    "colorful flowers and sturdy oak trees. The scene is bathed in warm sunlight, "\
    "and the air is filled with a sense of adventure and excitement as "\
    "the playful kitten clutches a tiny backpack, ready to embark on "\
    "its first day of learning among cheerful classmates "\
    "and whimsical classroom decorations."
  end

  describe "#response_body" do
    context "when the response is successful" do
      it "returns the content of the message" do
        VCR.use_cassette("chat_gpt_response_success") do
          expect(prompt_generator.response_body).to eq(expected_response)
        end
      end
    end

    context "when the response is not successful" do
      it "raises a NoResponseError" do
        allow_any_instance_of(Faraday::Response).to receive(:success?).and_return(false)
        expect { prompt_generator.response_body }.to raise_error(::ChatGpt::NoResponseError)
      end
    end
  end
end
