require "rails_helper"

describe TelegramIntegration::CallbackQueryDispatcher do
  subject(:dispatch) do
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
            chat_id:,
            tg_message_id:,
            callback_query_id:
          )
      end
    end

    context "when handled interactor fails with image not ready" do
      let(:button_request) { "kling_2_1_pro_image_to_video" }
      let(:failure_result) do
        double("Interactor::Context", failure?: true, error: ImageNotReadyError)
      end

      before do
        allow(MediaGenerator::ButtonHandler::HandleButton)
          .to receive(:call)
          .and_return(failure_result)
        allow(TelegramIntegration::SendAlertCallbackQuery).to receive(:call)
      end

      it "shows callback alert and does not raise" do
        expect { dispatch }.not_to raise_error
        expect(TelegramIntegration::SendAlertCallbackQuery).to have_received(:call).with(
          callback_query_id:,
          text: I18n.t("errors.image_not_ready")
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
