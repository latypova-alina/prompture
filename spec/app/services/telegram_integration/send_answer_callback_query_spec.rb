require "rails_helper"

describe TelegramIntegration::SendAnswerCallbackQuery do
  subject { described_class.call(callback_query_id:, button_request:) }

  let(:callback_query_id) { "abc123" }
  let(:button_request) { create(:button_image_processing_request) }
  let(:bot) { instance_double(Telegram::Bot::Client) }

  before do
    allow(Telegram).to receive(:bot).and_return(bot)
    allow(bot).to receive(:answer_callback_query)
  end

  it "calls Telegram.bot.answer_callback_query with correct arguments" do
    expected_text =
      I18n.t("telegram.generation.processing", process_name: "Flux image")

    expect(bot).to receive(:answer_callback_query).with(
      callback_query_id:,
      text: expected_text,
      show_alert: false
    )

    subject
  end

  context "when process_name is provided directly" do
    subject { described_class.call(callback_query_id:, process_name: "Veo 3.1 Lite video") }

    it "uses the provided process name in the toast" do
      expected_text = I18n.t("telegram.generation.processing", process_name: "Veo 3.1 Lite video")

      expect(bot).to receive(:answer_callback_query).with(
        callback_query_id:,
        text: expected_text,
        show_alert: false
      )

      subject
    end
  end

  context "when Telegram rejects the callback query" do
    before do
      allow(bot).to receive(:answer_callback_query)
        .and_raise(Telegram::Bot::Error, "query is too old")
    end

    it "does not raise" do
      expect { subject }.not_to raise_error
    end
  end
end
