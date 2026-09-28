require "rails_helper"

describe TermsGate::Check do
  subject(:call) { described_class.call(user:, chat_id:, locale:) }

  let(:chat_id) { 456 }
  let(:locale) { "en" }
  let(:telegram_bot) { double }

  before do
    allow(Telegram).to receive(:bot).and_return(telegram_bot)
    allow(telegram_bot).to receive(:send_message)
  end

  context "when the user has accepted the current terms" do
    let(:user) { create(:user, :terms_accepted) }

    it "returns true" do
      expect(call).to eq(true)
    end

    it "does not send a gate message" do
      call

      expect(telegram_bot).not_to have_received(:send_message)
    end
  end

  context "when the user has not accepted the current terms" do
    let(:user) { create(:user) }

    it "returns false" do
      expect(call).to eq(false)
    end

    it "sends the gate message to the chat" do
      call

      expect(telegram_bot).to have_received(:send_message).with(
        chat_id:,
        **TermsGate::Presenter.new(locale:).reply_data
      )
    end
  end
end
