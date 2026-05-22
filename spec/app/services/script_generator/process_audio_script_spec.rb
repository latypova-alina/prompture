require "rails_helper"

describe ScriptGenerator::ProcessAudioScript do
  subject(:service) { described_class.new(chat_id:) }

  let(:chat_id) { 456 }
  let(:script) { "Here's the brutal truth." }
  let(:user) { create(:user, chat_id:) }
  let(:command_request) { create(:command_prompt_to_audio_request, chat_id:, user:) }
  let(:result_context) { double("Interactor::Context", failure?: false) }

  before do
    allow(User).to receive(:find_by!).with(chat_id:).and_return(user)
    allow(CommandPromptToAudioRequest).to receive(:create!).with(chat_id:, user:).and_return(command_request)
    allow(AudioScriptProcessor::ProcessScript).to receive(:call).and_return(result_context)
  end

  describe "#call" do
    it "delegates to AudioScriptProcessor::ProcessScript with script, command_request, and chat_id" do
      service.call(script:)

      expect(AudioScriptProcessor::ProcessScript).to have_received(:call).with(
        script:,
        command_request:,
        chat_id:,
        voice: nil
      )
    end

    it "forwards voice when provided" do
      service.call(script:, voice: "knox_dark")

      expect(AudioScriptProcessor::ProcessScript).to have_received(:call).with(
        script:,
        command_request:,
        chat_id:,
        voice: "knox_dark"
      )
    end

    context "when audio script processor returns failure" do
      let(:error) { StandardError.new("boom") }
      let(:result_context) { double("Interactor::Context", failure?: true, error:) }

      it "raises the context error" do
        expect { service.call(script:) }.to raise_error(error)
      end
    end
  end
end
