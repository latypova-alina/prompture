require "rails_helper"

describe HandleCommand do
  subject { described_class.call(command:, chat_id:) }

  let(:command) { "prompt_to_image" }
  let!(:user) { create(:user, chat_id:) }
  let(:chat_id) { 456 }

  it "creates a command request" do
    expect { subject }.to change(CommandPromptToImageRequest, :count).from(0).to(1)
  end

  context "when command is unknown" do
    let(:command) { "unknown_command" }

    it "fails with CommandUnknownError" do
      result = subject

      expect(result).to be_failure
      expect(result.error).to eq(CommandUnknownError)
    end
  end
end
