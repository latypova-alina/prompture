require "rails_helper"

describe ScriptGenerator::ProcessCartoonCharacter do
  subject(:service_call) { described_class.call(chat_id: 456) }

  let(:cartoon_character_context) do
    instance_double(
      ScriptGenerator::CartoonCharacterContext,
      character_description: "A blue Baby with pigtails, wearing a bow."
    )
  end
  let(:script_processor) { instance_double(ScriptGenerator::ProcessScript::ForVideo) }

  before do
    allow(ScriptGenerator::CartoonCharacterContext)
      .to receive(:new)
      .with(chat_id: 456)
      .and_return(cartoon_character_context)
    allow(ScriptGenerator::ProcessScript::ForVideo)
      .to receive(:new)
      .with(chat_id: 456, category: ContentCategory::CARTOON_CHARACTER)
      .and_return(script_processor)
    allow(script_processor).to receive(:call)
  end

  it "processes character description as a script" do
    service_call

    expect(script_processor)
      .to have_received(:call)
      .with(script: "A blue Baby with pigtails, wearing a bow.")
  end
end
