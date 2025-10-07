require "rails_helper"

describe Strategies::Selector do
  let(:session) { { "prompt" => "some prompt" } }
  let(:button_request) { "extend_prompt" }

  subject { described_class.new(button_request, session) }

  describe "#strategy" do
    subject { super().strategy }

    it { is_expected.to be_an_instance_of(Strategies::ExtendPrompt) }

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
