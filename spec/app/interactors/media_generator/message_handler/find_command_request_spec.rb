require "rails_helper"

describe MediaGenerator::MessageHandler::FindCommandRequest do
  subject { described_class.call(chat_id: 456, command:) }

  let(:command) { "prompt_to_image" }
  let!(:user) { create(:user, chat_id: 456) }

  describe "#call" do
    context "when command is known and command request exists" do
      let!(:command_request) { create(:command_prompt_to_image_request, chat_id: 456) }

      it "assigns command_request to the context" do
        result = subject

        expect(result).to be_success
        expect(result.command_request).to eq(command_request)
      end
    end

    context "when command is unknown" do
      let(:command) { "unknown_command" }

      it "fails with CommandUnknownError" do
        result = subject

        expect(result).to be_failure
        expect(result.error).to eq(CommandUnknownError)
      end
    end

    context "when command is known but no command request exists" do
      it "fails with CommandRequestForgottenError" do
        result = subject

        expect(result).to be_failure
        expect(result.error).to eq(CommandRequestForgottenError)
      end
    end

    context "when command is prompt_to_image and the video workflow flag is enabled for the user" do
      before { Flipper.enable(:prompt_to_image_video_workflow, user) }

      let!(:command_request) { create(:command_prompt_to_video_request, chat_id: 456) }

      it "looks up the command request as a video request" do
        result = subject

        expect(result).to be_success
        expect(result.command_request).to eq(command_request)
      end
    end
  end
end
