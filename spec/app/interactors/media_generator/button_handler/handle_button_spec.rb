require "rails_helper"

describe MediaGenerator::ButtonHandler::HandleButton do
  describe ".organized" do
    it "organizes interactors in correct order" do
      expect(described_class.organized).to eq(
        [
          MediaGenerator::ButtonHandler::FindParentRequest,
          MediaGenerator::ButtonHandler::FindCommandRequest,
          MediaGenerator::ButtonHandler::CreateRequest,
          MediaGenerator::ButtonHandler::DecrementBalance,
          MediaGenerator::ButtonHandler::NotifyProcessingStarted,
          MediaGenerator::ButtonHandler::SendGenerationTask
        ]
      )
    end
  end

  describe "when the user can't afford the button" do
    subject(:result) { described_class.call(chat_id: 456, tg_message_id: 789, button_request: "flux_image") }

    let(:user) { create(:user, :with_custom_balance, credits: 0) }
    let(:command_request) { create(:command_prompt_to_image_request, user:) }
    let(:prompt_message) { create(:prompt_message, command_request:, parent_request: command_request) }
    let(:insufficient_credits_failure) { { status: "FAILED", failure_reason: "insufficient_credits" } }

    before do
      create(:bot_telegram_message, request: prompt_message, chat_id: 456, tg_message_id: 789)
      allow(MediaGenerator::ButtonHandler::SendGenerationTask).to receive(:call!)
      result
    end

    it { is_expected.to be_failure }
    it { expect(result.error).to eq(InsufficientCreditsError) }
    it { expect(ButtonImageProcessingRequest.sole).to have_attributes(insufficient_credits_failure) }
  end
end
