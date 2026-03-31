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
    context "when source telegram message exists" do
      before do
        create(:telegram_message, request: request.parent_request, tg_message_id: 123_456)
      end

      it "sends telegram message as reply" do
        call_service

        expect(TelegramIntegration::SendMessageWithButtons)
          .to have_received(:call)
          .with(
            reply_data: reply_data.merge(reply_to_message_id: 123_456),
            request:
          )
      end
    end

    context "when source telegram message does not exist" do
      it "sends telegram message without reply reference" do
        call_service

        expect(TelegramIntegration::SendMessageWithButtons)
          .to have_received(:call)
          .with(
            reply_data:,
            request:
          )
      end
    end

    context "when current request telegram message exists but parent message does not" do
      before do
        create(:telegram_message, request:, tg_message_id: 999_999)
      end

      it "sends telegram message without reply reference" do
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
end
