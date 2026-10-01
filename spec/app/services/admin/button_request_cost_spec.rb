require "rails_helper"

describe Admin::ButtonRequestCost do
  subject { described_class.call(klass, processor) }

  let(:klass) { ButtonImageProcessingRequest }
  let(:processor) { "flux_image" }

  it { is_expected.to eq(ButtonImageProcessingRequest.new(processor: "flux_image").cost) }

  context "when the processor is an edit processor" do
    let(:processor) { "nano_banana_edit_image" }

    it { is_expected.to eq(COSTS[:edit_image][:nano_banana_edit_image]) }
  end

  context "when the processor is missing" do
    let(:processor) { nil }

    it { is_expected.to be_nil }
  end

  context "when the class has no processor column" do
    let(:klass) { ButtonExtendPromptRequest }
    let(:processor) { nil }

    it { is_expected.to eq(COSTS[:prompt][:extend_prompt]) }
  end
end
