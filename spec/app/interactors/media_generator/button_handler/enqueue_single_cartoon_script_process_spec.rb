require "rails_helper"

describe MediaGenerator::ButtonHandler::EnqueueSingleCartoonScriptProcess do
  subject(:result) { described_class.call(command_request:) }

  let(:command_request) { create(:command_edit_image_request, chat_id: 456) }

  before do
    allow(ScriptGenerator::ProcessSingleCartoonScriptJob).to receive(:perform_async)
  end

  it "enqueues ProcessSingleCartoonScriptJob with chat_id" do
    expect(result).to be_success
    expect(ScriptGenerator::ProcessSingleCartoonScriptJob).to have_received(:perform_async).with(456)
  end
end
