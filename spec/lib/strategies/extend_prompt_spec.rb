require "rails_helper"

describe Strategies::ExtendPrompt do
  let(:session) { { "prompt" => "generate image prompt", "regenerate" => true } }
  let(:extended_prompt_object) { double(extended_prompt: "extended image prompt") }
  let(:presenter_object) { double(reply_data: "reply data") }

  subject { described_class.new(session) }

  describe "#reply_data" do
    subject { super().reply_data }

    before do
      allow(ExtendedPrompt).to receive(:new)
        .with("generate image prompt", "extend_description").and_return(extended_prompt_object)

      allow(MessagePresenter).to receive(:new)
        .with("extended image prompt", "prompt_message").and_return(presenter_object)
    end

    it { is_expected.to eq("reply data") }
  end
end
