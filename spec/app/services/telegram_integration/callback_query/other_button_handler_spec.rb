require "rails_helper"

describe TelegramIntegration::CallbackQuery::OtherButtonHandler do
  subject(:call_handler) do
    described_class.call(
      button_request:,
      chat_id:,
      tg_message_id:,
      callback_query_id:
    )
  end

  let(:chat_id) { 123 }
  let(:tg_message_id) { 456 }
  let(:callback_query_id) { "abc-123" }
  let(:success_result) { instance_double("Interactor::Context", failure?: false) }

  context "when button_request is check_generation_status" do
    let(:generation_request) { create(:button_video_processing_request) }
    let(:button_request) do
      "#{ButtonActions::CHECK_GENERATION_STATUS}:#{generation_request.id}:#{generation_request.class.name}"
    end

    before do
      allow(MediaGenerator::ButtonHandler::CheckGenerationStatus)
        .to receive(:call)
        .and_return(success_result)
      allow(MediaGenerator::ButtonHandler::HandleButton).to receive(:call)
    end

    it "calls CheckGenerationStatus" do
      call_handler

      expect(MediaGenerator::ButtonHandler::CheckGenerationStatus)
        .to have_received(:call)
        .with(button_request:, callback_query_id:)
      expect(MediaGenerator::ButtonHandler::HandleButton).not_to have_received(:call)
    end
  end

  context "when button_request is cancel_generation" do
    let(:generation_request) { create(:button_video_processing_request) }
    let(:button_request) do
      "#{ButtonActions::CANCEL_GENERATION}:#{generation_request.id}:#{generation_request.class.name}"
    end

    before do
      allow(MediaGenerator::ButtonHandler::CancelGeneration)
        .to receive(:call)
        .and_return(success_result)
      allow(MediaGenerator::ButtonHandler::HandleButton).to receive(:call)
    end

    it "calls CancelGeneration" do
      call_handler

      expect(MediaGenerator::ButtonHandler::CancelGeneration)
        .to have_received(:call)
        .with(button_request:, callback_query_id:)
      expect(MediaGenerator::ButtonHandler::HandleButton).not_to have_received(:call)
    end
  end
end
