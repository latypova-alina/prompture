require "rails_helper"

describe Generator::Media::Prompt::NotifySuccess::SendTelegramMessage do
  subject(:call_service) do
    described_class.call(reply_data:, request:)
  end

  let(:reply_data) { { text: "Prompt ready" } }
  let(:request) { create(:button_extend_prompt_request) }

  before do
    allow(TelegramIntegration::SendMessageWithButtons)
      .to receive(:call)
  end

  describe ".call" do
    it "sends telegram message with buttons" do
      call_service

      expect(TelegramIntegration::SendMessageWithButtons)
        .to have_received(:call)
        .with(
          reply_data:,
          request:
        )
    end
  end
end
