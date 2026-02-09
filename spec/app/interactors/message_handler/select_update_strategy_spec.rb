require "rails_helper"

describe MessageHandler::SelectUpdateStrategy do
  subject { described_class.call(message_text: "kitten", chat_id:, picture_id: nil, command:) }

  let(:chat_id) { 456 }
  let(:command) { "prompt_to_image" }
  let(:command_request) { create(:command_prompt_to_image_request) }
  let(:updater_class) { RecordUpdaters::CommandRequests::PromptToImage }
  let(:updater) { instance_double(updater_class, command_request:) }

  before { allow(updater_class).to receive(:new).and_return(updater) }

  it "assigns command_request from handler result" do
    expect(subject).to be_success
    expect(subject.command_request).to eq(command_request)
  end

  context "when command is unknown" do
    let(:command) { "unknown_command" }

    it "fails with CommandUnknownError" do
      result = subject

      expect(result).to be_failure
      expect(result.error).to eq(CommandUnknownError)
    end
  end

  context "when handler fails" do
    before do
      allow(updater_class).to receive(:new).and_raise(CommandRequestForgottenError)
    end

    it "fails with handler error" do
      result = subject

      expect(result).to be_failure
      expect(result.error).to eq(CommandRequestForgottenError)
    end
  end
end
