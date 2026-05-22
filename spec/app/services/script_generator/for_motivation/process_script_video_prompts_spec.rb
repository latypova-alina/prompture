require "rails_helper"

describe ScriptGenerator::ForMotivation::ProcessScriptVideoPrompts do
  subject(:service_call) { described_class.call(chat_id: 456, script: "Narration text") }

  let(:narration_video_prompts_context) do
    instance_double(ScriptGenerator::ForMotivation::NarrationVideoPromptsContext, prompts:)
  end
  let(:script_processor) { instance_double(ScriptGenerator::ProcessScript) }
  let(:prompts) { ["A crying person sitting alone in the rain", "Close-up of tears falling"] }

  before do
    allow(ScriptGenerator::ForMotivation::NarrationVideoPromptsContext).to receive(:new)
      .with(script: "Narration text")
      .and_return(narration_video_prompts_context)
    allow(ScriptGenerator::ProcessScript)
      .to receive(:new)
      .with(chat_id: 456, category: ContentCategory::MOTIVATION)
      .and_return(script_processor)
    allow(script_processor).to receive(:call)
  end

  it "processes each generated prompt as prompt_to_video" do
    service_call

    expect(script_processor).to have_received(:call).with(script: "A crying person sitting alone in the rain")
    expect(script_processor).to have_received(:call).with(script: "Close-up of tears falling")
    expect(script_processor).to have_received(:call).exactly(2).times
  end
end
