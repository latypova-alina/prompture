require "rails_helper"

describe ScriptGenerator::ProcessMotivationScript do
  subject(:service_call) { described_class.call(chat_id: 456, language: "en") }

  let(:motivation_script_context) do
    instance_double(ScriptGenerator::MotivationScriptContext, script_text: "Here's the brutal truth.")
  end
  let(:audio_script_processor) { instance_double(ScriptGenerator::ProcessAudioScript) }

  before do
    allow(ScriptGenerator::MotivationScriptContext).to receive(:new)
      .with(chat_id: 456, language: "en")
      .and_return(motivation_script_context)
    allow(ScriptGenerator::ProcessAudioScript).to receive(:new).with(chat_id: 456).and_return(audio_script_processor)
    allow(audio_script_processor).to receive(:call)
  end

  it "processes fetched script text as audio" do
    service_call

    expect(audio_script_processor).to have_received(:call).with(script: "Here's the brutal truth.")
  end
end
