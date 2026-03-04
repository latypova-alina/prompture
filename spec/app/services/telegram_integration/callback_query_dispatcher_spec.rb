require "rails_helper"

describe TelegramIntegration::CallbackQueryDispatcher do
  subject(:dispatch) do
    described_class.call(
      button_request:,
      image_url:,
      chat_id:,
      tg_message_id:,
      callback_query_id:
    )
  end

  let(:image_url) { "http://example.com/image.png" }
  let(:chat_id) { 123 }
  let(:tg_message_id) { 456 }
  let(:callback_query_id) { "abc-123" }

  let(:success_result) { instance_double("Interactor::Context", failure?: false) }
  let(:failure_result) do
    instance_double("Interactor::Context", failure?: true, error: StandardError.new("boom"))
  end

  describe ".call" do
    context "when button_request is set_locale command" do
      let(:button_request) { "set_locale:es" }

      before do
        allow(SetLocale::ButtonHandler::HandleButton)
          .to receive(:call)
          .and_return(success_result)
      end

      it "calls SetLocale::ButtonHandler::HandleButton with parsed locale" do
        dispatch

        expect(SetLocale::ButtonHandler::HandleButton)
          .to have_received(:call)
          .with(selected_locale: "es", chat_id:)
      end
    end

    context "when button_request is media command" do
      let(:button_request) { "mystic_image" }

      before do
        allow(MediaGenerator::ButtonHandler::HandleButton)
          .to receive(:call)
          .and_return(success_result)
      end

      it "calls MediaGenerator::ButtonHandler::HandleButton with correct arguments" do
        dispatch

        expect(MediaGenerator::ButtonHandler::HandleButton)
          .to have_received(:call)
          .with(
            button_request:,
            image_url:,
            chat_id:,
            tg_message_id:,
            callback_query_id:
          )
      end
    end

    context "when handled interactor returns failure" do
      let(:button_request) { "set_locale:es" }

      let(:failure_result) do
        double(
          failure?: true,
          error: StandardError.new("boom")
        )
      end

      before do
        allow(SetLocale::ButtonHandler::HandleButton)
          .to receive(:call)
          .and_return(failure_result)
      end

      it "raises the returned error" do
        expect { dispatch }.to raise_error(StandardError, "boom")
      end
    end
  end
end
