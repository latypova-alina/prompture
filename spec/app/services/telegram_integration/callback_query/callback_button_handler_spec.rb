require "rails_helper"

describe TelegramIntegration::CallbackQuery::CallbackButtonHandler do
  subject(:handled_button) do
    described_class.new(
      button_request:,
      chat_id:,
      tg_message_id:,
      callback_query_id:
    ).handled_button
  end

  let(:chat_id) { 123 }
  let(:tg_message_id) { 456 }
  let(:callback_query_id) { "abc-123" }
  let(:success_result) { instance_double("Interactor::Context", failure?: false) }

  context "when button_request is set_locale command" do
    let(:button_request) { "set_locale:es" }

    before do
      allow(SetLocale::ButtonHandler::HandleButton).to receive(:call).and_return(success_result)
    end

    it "calls SetLocale::ButtonHandler::HandleButton with parsed locale" do
      handled_button

      expect(SetLocale::ButtonHandler::HandleButton)
        .to have_received(:call)
        .with(selected_locale: "es", chat_id:)
    end
  end

  context "when button_request is get_audio_samples" do
    let(:button_request) { "get_audio_samples" }

    before do
      allow(Audio::SendVoiceSamples).to receive(:call).and_return(success_result)
      allow(MediaGenerator::ButtonHandler::HandleButton).to receive(:call)
    end

    it "calls Audio::SendVoiceSamples without going through media generation" do
      handled_button

      expect(Audio::SendVoiceSamples).to have_received(:call).with(chat_id:)
      expect(MediaGenerator::ButtonHandler::HandleButton).not_to have_received(:call)
    end
  end

  context "when button_request is generate_cartoon_video" do
    let(:button_request) { "generate_cartoon_video" }

    before do
      allow(MediaGenerator::ButtonHandler::HandleGenerateCartoonVideoButton)
        .to receive(:call)
        .and_return(success_result)
      allow(MediaGenerator::ButtonHandler::HandleButton).to receive(:call)
    end

    it "calls HandleGenerateCartoonVideoButton" do
      handled_button

      expect(MediaGenerator::ButtonHandler::HandleGenerateCartoonVideoButton)
        .to have_received(:call)
        .with(
          button_request:,
          chat_id:,
          tg_message_id:,
          callback_query_id:
        )
      expect(MediaGenerator::ButtonHandler::HandleButton).not_to have_received(:call)
    end
  end

  context "when button_request is media command" do
    let(:button_request) { "flux_image" }

    before do
      allow(MediaGenerator::ButtonHandler::HandleButton).to receive(:call).and_return(success_result)
    end

    it "calls MediaGenerator::ButtonHandler::HandleButton with correct arguments" do
      handled_button

      expect(MediaGenerator::ButtonHandler::HandleButton)
        .to have_received(:call)
        .with(
          button_request:,
          chat_id:,
          tg_message_id:,
          callback_query_id:
        )
    end
  end
end
