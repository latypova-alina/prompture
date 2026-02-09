require "rails_helper"

describe RecordUpdaters::CommandRequests::PromptToImage do
  subject { described_class.new(message_text, chat_id, picture_id).command_request }

  let(:chat_id) { 456 }

  context "when valid text message is provided" do
    let(:message_text) { "cute white kitten" }
    let(:picture_id) { nil }

    let!(:command_request) do
      create(
        :command_prompt_to_image_request,
        chat_id: chat_id,
        prompt: nil
      )
    end

    it "updates prompt on the last command request" do
      result = subject

      expect(result.prompt).to eq(message_text)
    end
  end

  context "when picture is provided" do
    let(:message_text) { "cute white kitten" }
    let(:picture_id) { "pic-123" }

    let!(:command_request) do
      create(:command_prompt_to_image_request, chat_id: chat_id)
    end

    it "raises MessageTypeError" do
      expect do
        subject
      end.to raise_error(MessageTypeError)
    end
  end

  context "when message text is blank" do
    let(:message_text) { nil }
    let(:picture_id) { nil }

    let!(:command_request) do
      create(:command_prompt_to_image_request, chat_id: chat_id)
    end

    it "raises MessageTypeError" do
      expect do
        subject
      end.to raise_error(MessageTypeError)
    end
  end

  context "when no previous command request exists" do
    let(:message_text) { "text only" }
    let(:picture_id) { nil }

    it "raises CommandRequestForgottenError" do
      expect do
        subject
      end.to raise_error(CommandRequestForgottenError)
    end
  end
end
