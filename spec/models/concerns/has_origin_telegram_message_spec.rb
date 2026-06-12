require "rails_helper"

RSpec.describe HasOriginTelegramMessage do
  subject(:origin_telegram_message_id) { request.origin_telegram_message_id }

  let(:command_request) { create(:command_edit_image_request) }
  let(:image_request) do
    create(
      :button_image_processing_request,
      :completed,
      command_request:,
      parent_request: command_request
    )
  end
  let(:prompt_message) do
    create(
      :prompt_message,
      command_request:,
      parent_request: image_request
    )
  end
  let(:request) do
    create(
      :button_video_processing_request,
      command_request: create(:command_prompt_to_video_request, user: command_request.user),
      parent_request: prompt_message
    )
  end

  context "when a parent in the chain has a bot telegram message" do
    before do
      create(:bot_telegram_message, request: image_request, tg_message_id: 6280)
    end

    it "returns the origin message id" do
      expect(origin_telegram_message_id).to eq(6280)
    end
  end

  context "when no parent in the chain has a bot telegram message" do
    it "returns nil" do
      expect(origin_telegram_message_id).to be_nil
    end
  end
end
