require "rails_helper"

describe ScriptGenerator::ForMotivation::ProcessMotivationScript do
  subject(:service_call) { described_class.call(chat_id: 456, language: "en") }

  let(:motivation_script_context) do
    instance_double(ScriptGenerator::ForMotivation::MotivationScriptContext, script_text: "Here's the brutal truth.")
  end
  let(:audio_script_processor) { instance_double(ScriptGenerator::ProcessAudioScript) }

  before do
    allow(ScriptGenerator::ForMotivation::MotivationScriptContext).to receive(:new)
      .with(chat_id: 456, language: "en")
      .and_return(motivation_script_context)
    allow(ScriptGenerator::ProcessAudioScript).to receive(:new).with(chat_id: 456).and_return(audio_script_processor)
    allow(audio_script_processor).to receive(:call)
  end

  it "processes fetched script text as audio with language-specific voice" do
    service_call

    expect(audio_script_processor).to have_received(:call).with(
      script: "Here's the brutal truth.",
      voice: "adam"
    )
  end

  context "when language is Russian" do
    subject(:service_call) { described_class.call(chat_id: 456, language: "ru") }

    before do
      allow(ScriptGenerator::ForMotivation::MotivationScriptContext).to receive(:new)
        .with(chat_id: 456, language: "ru")
        .and_return(motivation_script_context)
    end

    it "uses knox_dark voice" do
      service_call

      expect(audio_script_processor).to have_received(:call).with(
        script: "Here's the brutal truth.",
        voice: "knox_dark"
      )
    end
  end
end
