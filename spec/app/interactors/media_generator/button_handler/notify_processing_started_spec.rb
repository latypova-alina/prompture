require "rails_helper"

describe MediaGenerator::ButtonHandler::NotifyProcessingStarted do
  subject(:result) do
    described_class.call(callback_query_id:, button_request_record:)
  end

  let(:callback_query_id) { "abc123" }
  let(:button_request_record) { create(:button_image_processing_request) }

  describe "#call" do
    it "calls TelegramIntegration::SendAnswerCallbackQuery with correct arguments" do
      expect(TelegramIntegration::SendAnswerCallbackQuery)
        .to receive(:call)
        .with(
          callback_query_id:,
          button_request: button_request_record
        )

      result
    end

    it "is successful" do
      allow(TelegramIntegration::SendAnswerCallbackQuery).to receive(:call)

      expect(result).to be_success
    end
  end
end
