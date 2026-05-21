require "rails_helper"

describe ScriptGenerator::ProcessMotivationPrompts do
  subject(:service_call) { described_class.call(chat_id: 456) }

  let(:motivation_prompt_context) do
    instance_double(ScriptGenerator::MotivationPromptContext, prompts:)
  end
  let(:script_processor) { instance_double(ScriptGenerator::ProcessScript) }
  let(:prompts) { ["Cinematic forest scene", "Rainy city rooftop"] }

  before do
    allow(ScriptGenerator::MotivationPromptContext).to receive(:new)
      .with(chat_id: 456)
      .and_return(motivation_prompt_context)
    allow(ScriptGenerator::ProcessScript)
      .to receive(:new)
      .with(chat_id: 456, category: ContentCategory::MOTIVATION)
      .and_return(script_processor)
    allow(script_processor).to receive(:call)
  end

  it "processes each motivation prompt" do
    service_call

    expect(script_processor).to have_received(:call).with(script: "Cinematic forest scene")
    expect(script_processor).to have_received(:call).with(script: "Rainy city rooftop")
    expect(script_processor).to have_received(:call).exactly(2).times
  end
end
