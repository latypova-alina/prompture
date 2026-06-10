require "rails_helper"

describe ScriptGenerator::ForMotivation::ProcessScriptVideoPrompts do
  subject(:service_call) { described_class.call(chat_id: 456, script: "Narration text") }

  let(:motivation_prompt_context) do
    instance_double(ScriptGenerator::ForMotivation::MotivationPromptContext, scenes:)
  end
  let(:script_processor) { instance_double(ScriptGenerator::ProcessScript::ForVideo) }
  let(:scenes) do
    [
      ScriptGenerator::ForMotivation::VideoScene.new(
        "text" => "A crying person sitting alone in the rain",
        "subcategory" => "cry"
      ),
      ScriptGenerator::ForMotivation::VideoScene.new(
        "text" => "Close-up of tears falling",
        "subcategory" => "sadness"
      )
    ]
  end

  before do
    allow(ScriptGenerator::ForMotivation::MotivationPromptContext).to receive(:new)
      .with(script: "Narration text")
      .and_return(motivation_prompt_context)
    allow(ScriptGenerator::ProcessScript::ForVideo)
      .to receive(:new)
      .with(chat_id: 456, category: ContentCategory::MOTIVATION)
      .and_return(script_processor)
    allow(script_processor).to receive(:call)
  end

  it "processes each generated prompt as prompt_to_video" do
    service_call

    expect(script_processor).to have_received(:call).with(
      script: "A crying person sitting alone in the rain",
      subcategory: "cry"
    )
    expect(script_processor).to have_received(:call).with(
      script: "Close-up of tears falling",
      subcategory: "sadness"
    )
    expect(script_processor).to have_received(:call).exactly(2).times
  end
end
