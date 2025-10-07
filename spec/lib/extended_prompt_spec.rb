require "rails_helper"

describe ExtendedPrompt do
  let(:prompt) { "This is a test prompt" }
  let(:button_request) { "extend_description" }
  let(:extended_prompt_instance) { described_class.new(prompt, button_request) }

  describe "#extended_prompt" do
    let(:extended_prompt_double) { double("ExtendPrompt", extended_prompt: "Extended prompt") }

    before do
      allow(ExtendPrompt).to receive(:call).with(prompt:).and_return(extended_prompt_double)
    end

    it "calls ExtendPrompt.call and returns the extended prompt" do
      expect(extended_prompt_instance.extended_prompt).to eq("Extended prompt")
      expect(ExtendPrompt).to have_received(:call).with(prompt: prompt)
    end

    context "when button_request is not VALID_REQUEST" do
      let(:button_request) { "other_request" }

      it "returns the original prompt" do
        expect(extended_prompt_instance.extended_prompt).to eq(prompt)
      end
    end
  end
end
