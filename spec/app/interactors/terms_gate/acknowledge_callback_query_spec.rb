require "rails_helper"

describe TermsGate::AcknowledgeCallbackQuery do
  subject(:call) { described_class.call(callback_query_id:) }

  let(:callback_query_id) { "12345" }
  let(:telegram_bot) { double }

  before do
    allow(Telegram).to receive(:bot).and_return(telegram_bot)
    allow(telegram_bot).to receive(:answer_callback_query)
  end

  it "answers the callback query" do
    call

    expect(telegram_bot).to have_received(:answer_callback_query).with(callback_query_id:)
  end

  context "when callback_query_id is blank" do
    let(:callback_query_id) { nil }

    it "does not answer the callback query" do
      call

      expect(telegram_bot).not_to have_received(:answer_callback_query)
    end
  end

  context "when Telegram returns an error" do
    before do
      allow(telegram_bot).to receive(:answer_callback_query).and_raise(Telegram::Bot::Error.new("boom"))
    end

    it "does not raise" do
      expect { call }.not_to raise_error
    end
  end
end
