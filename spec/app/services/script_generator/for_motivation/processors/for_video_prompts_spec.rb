require "rails_helper"

describe ScriptGenerator::ForMotivation::Processors::ForVideoPrompts do
  subject(:service_call) { described_class.call(chat_id: 456, script: "Narration text") }

  let(:motivation_prompt_context) do
    instance_double(ScriptGenerator::ForMotivation::PromptContext, scenes:)
  end
  let(:script_processor) { instance_double(ScriptGenerator::ProcessScene::ForVideo) }
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
    allow(ScriptGenerator::ForMotivation::PromptContext).to receive(:new)
      .with(script: "Narration text")
      .and_return(motivation_prompt_context)
    allow(ScriptGenerator::ProcessScene::ForVideo)
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
