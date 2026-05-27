require "rails_helper"

describe ScriptGenerator::ProcessBrainrotCharacter do
  subject(:service_call) { described_class.call(chat_id: 456) }

  let(:brainrot_character_context) do
    instance_double(
      ScriptGenerator::BrainrotCharacterContext,
      character_description: "A semi-realistic banana with crab claws"
    )
  end
  let(:script_processor) { instance_double(ScriptGenerator::ProcessScript) }

  before do
    allow(ScriptGenerator::BrainrotCharacterContext)
      .to receive(:new)
      .with(chat_id: 456)
      .and_return(brainrot_character_context)
    allow(ScriptGenerator::ProcessScript)
      .to receive(:new)
      .with(chat_id: 456, category: ContentCategory::BRAINROT_CHARACTER)
      .and_return(script_processor)
    allow(script_processor).to receive(:call)
  end

  it "processes character description as a script" do
    service_call

    expect(script_processor)
      .to have_received(:call)
      .with(script: "A semi-realistic banana with crab claws")
  end
end
