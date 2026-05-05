require "rails_helper"

describe ScriptGenerator::ProcessScript do
  subject(:service) { described_class.new(chat_id:) }

  let(:chat_id) { 456 }
  let(:script) { "A dramatic city sunset shot." }
  let(:user) { create(:user, chat_id:) }
  let(:command_request) { create(:command_prompt_to_video_request, chat_id:, user:) }
  let(:result_context) { double("Interactor::Context", failure?: false) }

  before do
    allow(User).to receive(:find_by!).with(chat_id:).and_return(user)
    allow(CommandPromptToVideoRequest).to receive(:create!).with(chat_id:, user:).and_return(command_request)
    allow(ScriptProcessor::ProcessScript).to receive(:call).and_return(result_context)
  end

  describe "#call" do
    it "delegates to ScriptProcessor::ProcessScript with script, command_request, and chat_id" do
      service.call(script:)

      expect(ScriptProcessor::ProcessScript).to have_received(:call).with(
        script:,
        command_request:,
        chat_id:
      )
    end

    context "when script processor returns failure" do
      let(:error) { StandardError.new("boom") }
      let(:result_context) { double("Interactor::Context", failure?: true, error:) }

      it "raises the context error" do
        expect { service.call(script:) }.to raise_error(error)
      end
    end

    it "reuses memoized command_request for multiple scripts" do
      service.call(script: "scene one")
      service.call(script: "scene two")

      expect(CommandPromptToVideoRequest).to have_received(:create!).once
    end
  end
end
