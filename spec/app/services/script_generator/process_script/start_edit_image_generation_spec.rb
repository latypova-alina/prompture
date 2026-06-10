require "rails_helper"

describe ScriptGenerator::ProcessScript::StartEditImageGeneration do
  subject(:start_generation) { described_class.call(command_request:) }

  let(:command_request) { create(:command_edit_image_request) }
  let(:generation_context) do
    double("Interactor::Context", failure?: false)
  end

  before do
    allow(MediaGenerator::MessageHandler::EditImageMessageHandler::StartGeneration)
      .to receive(:call)
      .and_return(generation_context)
  end

  it "starts nano banana edit image generation" do
    start_generation

    expect(MediaGenerator::MessageHandler::EditImageMessageHandler::StartGeneration)
      .to have_received(:call)
      .with(command_request:, button_request: "nano_banana_edit_image")
  end

  context "when generation fails" do
    let(:generation_context) do
      double("Interactor::Context", failure?: true, error: InsufficientCreditsError)
    end

    it "raises the error" do
      expect { start_generation }.to raise_error(InsufficientCreditsError)
    end
  end
end
