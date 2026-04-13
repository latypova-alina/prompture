require "rails_helper"

describe TelegramIntegration::SendAlertCallbackQuery do
  subject(:call_service) { described_class.call(callback_query_id:, text:) }

  let(:callback_query_id) { "abc-123" }
  let(:text) { "Alert text" }
  let(:bot) { instance_double(Telegram::Bot::Client) }

  before do
    allow(Telegram).to receive(:bot).and_return(bot)
    allow(bot).to receive(:answer_callback_query)
  end

  it "sends callback query alert" do
    call_service

    expect(bot).to have_received(:answer_callback_query).with(
      callback_query_id:,
      text:,
      show_alert: true
    )
  end
end
