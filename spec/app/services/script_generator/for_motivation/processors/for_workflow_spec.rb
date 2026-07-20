require "rails_helper"

describe ScriptGenerator::ForMotivation::Processors::ForWorkflow do
  subject(:service_call) { described_class.call(chat_id: 456, language: "en") }

  let(:motivation_script_context) do
    instance_double(ScriptGenerator::ForMotivation::ScriptContext, script_text: "Here's the brutal truth.")
  end
  let(:audio_script_processor) { instance_double(ScriptGenerator::ForMotivation::Processors::ForAudioScript) }

  before do
    allow(ScriptGenerator::ForMotivation::ScriptContext).to receive(:new)
      .with(language: "en")
      .and_return(motivation_script_context)
    allow(ScriptGenerator::ForMotivation::Processors::ForAudioScript)
      .to receive(:new)
      .with(chat_id: 456)
      .and_return(audio_script_processor)
    allow(audio_script_processor).to receive(:call)
    allow(ScriptGenerator::ForMotivation::Processors::ForVideoPrompts).to receive(:call)
  end

  it "fetches motivation script, generates audio, then creates video prompts" do
    service_call

    expect(audio_script_processor).to have_received(:call).with(
      script: "Here's the brutal truth.",
      voice: "adam"
    )
    expect(ScriptGenerator::ForMotivation::Processors::ForVideoPrompts).to have_received(:call).with(
      chat_id: 456,
      script: "Here's the brutal truth."
    )
  end
end
