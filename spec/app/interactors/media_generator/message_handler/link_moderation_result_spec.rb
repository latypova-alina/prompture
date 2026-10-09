require "rails_helper"

describe MediaGenerator::MessageHandler::LinkModerationResult do
  subject { moderation_result.reload.moderatable }

  let(:command_request) { create(:command_prompt_to_image_request) }
  let(:prompt_message) { create(:prompt_message, command_request:, parent_request: command_request) }
  let(:moderation_result) do
    ModerationResult.create!(command_request:, input_kind: "text", input_text: "a cat", model: "omni-moderation-latest")
  end

  before { described_class.call(moderation_result:, prompt_message:) }

  it { is_expected.to eq(prompt_message) }
end
