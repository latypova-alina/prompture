require "rails_helper"

describe ScriptGenerator::ProcessRandomCharacter do
  subject(:service_call) { described_class.call(chat_id: 456) }

  let(:character_context) { instance_double(ScriptGenerator::CharacterContext, character_description: "A cheerful robot baker") }
  let(:script_processor) { instance_double(ScriptGenerator::ProcessScript) }

  before do
    allow(ScriptGenerator::CharacterContext).to receive(:new).with(chat_id: 456).and_return(character_context)
    allow(ScriptGenerator::ProcessScript)
      .to receive(:new)
      .with(chat_id: 456, category: ContentCategory::RANDOM_CHARACTER)
      .and_return(script_processor)
    allow(script_processor).to receive(:call)
  end

  it "processes character description as a script" do
    service_call

    expect(script_processor).to have_received(:call).with(script: "A cheerful robot baker")
  end
end
