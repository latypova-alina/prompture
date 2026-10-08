require "rails_helper"

describe MediaGenerator::MessageHandler::ModerateMessage do
  subject(:result) { described_class.call(message_text:, command_request:) }

  let(:message_text) { "cute white kitten" }
  let(:command_request) { create(:command_prompt_to_image_request) }
  let(:blocked) { false }

  before do
    stub_openai_moderation(blocked:)
    result
  end

  context "when moderation blocks the message" do
    let(:blocked) { true }

    it { is_expected.to be_failure }
    it { expect(result.error).to eq(ModerationError) }

    it "keeps the blocked prompt on the moderation result" do
      expect(ModerationResult.sole).to have_attributes(
        command_request:, moderatable: nil, input_kind: "text", input_text: message_text,
        blocked: true, blocked_by: "sexual_minors_category", openai_flagged: true
      )
    end

    it { expect(PromptMessage.count).to eq(0) }
  end

  context "when moderation lets the message through" do
    it { is_expected.to be_success }
    it { expect(result.moderation_result).to have_attributes(blocked: false, input_text: message_text) }
  end

  context "when the moderation call fails" do
    subject(:result) { nil }

    before { stub_request(:post, "https://api.openai.com/v1/moderations").to_return(status: 500) }

    it "records the error and re-raises" do
      expect { described_class.call(message_text:, command_request:) }.to raise_error(ModerationRequestError)
      expect(ModerationResult.last).to have_attributes(result: nil, error: be_present, blocked: false)
    end
  end
end
