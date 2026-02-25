require "rails_helper"

describe MediaGenerator::MessageHandler::CreatePromptMessage do
  subject { described_class.call(message_text:, chat_id: 456, command_request:) }

  let(:message_text) { "cute white kitten" }
  let(:chat_id) { 456 }
  let(:command_request) { create(:command_prompt_to_image_request) }

  describe "#call" do
    it "creates a PromptMessage record" do
      expect { subject }
        .to change(PromptMessage, :count).by(1)
    end

    it "assigns prompt_message to the context" do
      result = subject

      expect(result.prompt_message).to be_a(PromptMessage)
    end

    it "sets correct attributes on PromptMessage" do
      result = subject
      prompt_message = result.prompt_message

      expect(prompt_message.prompt).to eq(message_text)
      expect(prompt_message.parent_request).to eq(command_request)
      expect(prompt_message.command_request).to eq(command_request)
    end
  end
end
