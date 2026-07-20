require "rails_helper"

describe ScriptGenerator::ForCats::Processor do
  subject(:service_call) { described_class.call(chat_id: 456, template_name:) }

  let(:template_name) { nil }
  let(:context) { instance_double(ScriptGenerator::ForCats::Context, script_array:) }
  let(:script_processor) { instance_double(ScriptGenerator::ProcessScene::ForVideo) }
  let(:script_array) { "first scene\n\n second scene \n\n\nthird scene" }

  before do
    allow(ScriptGenerator::ForCats::Context).to receive(:new).with(chat_id: 456, template_name:).and_return(context)
    allow(ScriptGenerator::ProcessScene::ForVideo)
      .to receive(:new)
      .with(chat_id: 456, category: ContentCategory::TEMPLATE)
      .and_return(script_processor)
    allow(script_processor).to receive(:call)
  end

  it "splits scripts by paragraph and processes each non-blank script" do
    service_call

    expect(script_processor).to have_received(:call).with(script: "first scene")
    expect(script_processor).to have_received(:call).with(script: "second scene")
    expect(script_processor).to have_received(:call).with(script: "third scene")
    expect(script_processor).to have_received(:call).exactly(3).times
  end

  context "when template_name is provided" do
    let(:template_name) { "Horror Story" }

    before do
      allow(ScriptGenerator::ProcessScene::ForVideo)
        .to receive(:new)
        .with(chat_id: 456, category: "horror_story")
        .and_return(script_processor)
    end

    it "uses normalized template name as category" do
      service_call

      expect(ScriptGenerator::ProcessScene::ForVideo).to have_received(:new).with(chat_id: 456,
                                                                                  category: "horror_story")
    end
  end
end
