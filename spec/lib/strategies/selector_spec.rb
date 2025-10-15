require "rails_helper"

describe Strategies::Selector do
  let(:prompt) { "some prompt" }
  let(:session) { { "prompt" => prompt } }
  let(:button_request) { "extend_prompt" }

  subject { described_class.new(button_request, session) }

  describe "#strategy" do
    subject { super().strategy }

    context "when chatgpt request is successful" do
      include_context "stub chat_gpt success request"

      it "returns an instance of the correct strategy" do
        is_expected.to be_an_instance_of(Strategies::ExtendPrompt)
      end
    end

    context "when chatgpt raises error" do
      before do
        allow(Strategies::ExtendPrompt).to receive(:new)
          .and_raise(ChatGpt::ResponseError)
      end

      it "raises ChatGpt::ResponseError" do
        expect { subject }
          .to raise_error(ChatGpt::ResponseError)
      end
    end

    context "when button_request is an image action" do
      let(:button_request) { "mystic_image" }

      it { is_expected.to be_an_instance_of(Strategies::GenerateImage) }
    end

    context "when button_request is not recognized" do
      let(:button_request) { "unknown_action" }

      it { is_expected.to be_nil }
    end
  end
end
