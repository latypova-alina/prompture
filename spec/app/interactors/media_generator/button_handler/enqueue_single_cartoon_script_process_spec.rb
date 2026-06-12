require "rails_helper"

describe MediaGenerator::ButtonHandler::EnqueueSingleCartoonScriptProcess do
  subject(:result) { described_class.call(command_request:) }

  let(:command_request) do
    create(:command_edit_image_request, chat_id: 456, category: ContentCategory::CARTOON_SCRIPT)
  end

  before do
    allow(ScriptGenerator::ProcessSingleCartoonScriptJob).to receive(:perform_async)
  end

  it "enqueues ProcessSingleCartoonScriptJob with chat_id and category" do
    expect(result).to be_success
    expect(ScriptGenerator::ProcessSingleCartoonScriptJob).to have_received(:perform_async).with(
      456,
      ContentCategory::CARTOON_SCRIPT
    )
  end

  context "when command request is cartoon shorts script" do
    let(:command_request) do
      create(:command_edit_image_request, chat_id: 456, category: ContentCategory::CARTOON_SHORTS_SCRIPT)
    end

    it "enqueues job with cartoon shorts category" do
      expect(result).to be_success
      expect(ScriptGenerator::ProcessSingleCartoonScriptJob).to have_received(:perform_async).with(
        456,
        ContentCategory::CARTOON_SHORTS_SCRIPT
      )
    end
  end
end
