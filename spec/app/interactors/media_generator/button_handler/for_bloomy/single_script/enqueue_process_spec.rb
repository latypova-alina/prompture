require "rails_helper"

describe MediaGenerator::ButtonHandler::ForBloomy::SingleScript::EnqueueProcess do
  subject(:result) { described_class.call(command_request:) }

  let(:command_request) do
    create(:command_edit_image_request, chat_id: 456, category: ContentCategory::BLOOMY_CARTOON_SCRIPT)
  end

  before do
    allow(ScriptGenerator::Process::ForBloomy::SingleScriptJob).to receive(:perform_async)
  end

  it "enqueues SingleScriptJob with chat_id and category" do
    expect(result).to be_success
    expect(ScriptGenerator::Process::ForBloomy::SingleScriptJob).to have_received(:perform_async).with(
      456,
      ContentCategory::BLOOMY_CARTOON_SCRIPT
    )
  end

  context "when command request is cartoon shorts script" do
    let(:command_request) do
      create(:command_edit_image_request, chat_id: 456, category: ContentCategory::CARTOON_BLOOMY_SHORTS_SCRIPT)
    end

    it "enqueues job with cartoon shorts category" do
      expect(result).to be_success
      expect(ScriptGenerator::Process::ForBloomy::SingleScriptJob).to have_received(:perform_async).with(
        456,
        ContentCategory::CARTOON_BLOOMY_SHORTS_SCRIPT
      )
    end
  end
end
