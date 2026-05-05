require "rails_helper"

describe ScriptGenerator::GenerateRandomScript do
  subject(:service_call) { described_class.call(chat_id: 456) }

  let(:script_context) { instance_double(ScriptGenerator::ScriptContext, script_array:) }
  let(:script_processor) { instance_double(ScriptGenerator::ProcessScript) }
  let(:script_array) { "first scene\n\n second scene \n\n\nthird scene" }

  before do
    allow(ScriptGenerator::ScriptContext).to receive(:new).with(chat_id: 456).and_return(script_context)
    allow(ScriptGenerator::ProcessScript).to receive(:new).with(chat_id: 456).and_return(script_processor)
    allow(script_processor).to receive(:call)
  end

  it "splits scripts by paragraph and processes each non-blank script" do
    service_call

    expect(script_processor).to have_received(:call).with(script: "first scene")
    expect(script_processor).to have_received(:call).with(script: "second scene")
    expect(script_processor).to have_received(:call).with(script: "third scene")
    expect(script_processor).to have_received(:call).exactly(3).times
  end
end
