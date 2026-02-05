require "rails_helper"

describe ButtonHandler::FindParentRequest do
  subject { described_class.call(chat_id:, tg_message_id:) }

  let(:chat_id) { 456 }
  let(:tg_message_id) { 789 }

  let(:command_request) { create(:command_prompt_to_image_request) }

  context "when parent telegram message exists" do
    let!(:telegram_message) do
      create(
        :telegram_message,
        chat_id:,
        tg_message_id:,
        request: command_request
      )
    end

    it "assigns parent_request from telegram message" do
      result = subject

      expect(result).to be_success
      expect(result.parent_request).to eq(command_request)
    end
  end

  context "when parent telegram message does not exist" do
    it "fails with ParentNotFoundError" do
      result = subject

      expect(result).to be_failure
      expect(result.error).to eq(ParentNotFoundError)
    end
  end
end
