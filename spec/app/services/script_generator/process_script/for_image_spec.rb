require "rails_helper"

describe ScriptGenerator::ProcessScript::ForImage do
  subject(:service) { described_class.new(chat_id:, category:) }

  let(:chat_id) { 456 }
  let(:category) { ContentCategory::CARTOON_SCRIPT }
  let(:script) { "A dramatic city sunset shot." }
  let(:user) { create(:user, chat_id:) }
  let(:command_request) { create(:command_prompt_to_image_request, chat_id:, user:, category:) }
  let(:result_context) { double("Interactor::Context", failure?: false) }

  before do
    allow(User).to receive(:find_by!).with(chat_id:).and_return(user)
    allow(CommandPromptToImageRequest).to receive(:create!).with(chat_id:, user:, category:).and_return(command_request)
    allow(ScriptProcessor::ProcessScript).to receive(:call).and_return(result_context)
  end

  describe "#call" do
    it "delegates to ScriptProcessor::ProcessScript with script, command_request, and chat_id" do
      service.call(script:)

      expect(ScriptProcessor::ProcessScript).to have_received(:call).with(
        script:,
        command_request:,
        chat_id:,
        subcategory: nil
      )
    end

    it "creates a command_prompt_to_image request" do
      service.call(script:)

      expect(CommandPromptToImageRequest).to have_received(:create!).once
    end

    it "reuses memoized command_request for multiple scripts" do
      service.call(script: "scene one")
      service.call(script: "scene two")

      expect(CommandPromptToImageRequest).to have_received(:create!).once
    end
  end
end
