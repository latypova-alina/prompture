require "rails_helper"

describe SetLocale::CommandHandler::HandleCommand do
  subject(:result) { described_class.call(chat_id:, locale:) }

  let(:chat_id) { 456 }
  let(:locale) { "es" }

  let(:bot) { instance_double(Telegram::Bot::Client) }
  let(:presenter) { instance_double(SetLocale::CommandHandlerPresenter) }

  let(:reply_data) do
    {
      text: "Choose your language",
      reply_markup: { inline_keyboard: [] }
    }
  end

  before do
    allow(Telegram).to receive(:bot).and_return(bot)
    allow(bot).to receive(:send_message)

    allow(SetLocale::CommandHandlerPresenter)
      .to receive(:new)
      .with(locale: locale)
      .and_return(presenter)

    allow(presenter)
      .to receive(:reply_data)
      .and_return(reply_data)
  end

  describe ".call" do
    it "initializes presenter with locale" do
      result

      expect(SetLocale::CommandHandlerPresenter)
        .to have_received(:new)
        .with(locale:)
    end

    it "sends telegram message with presenter reply_data" do
      expect(bot)
        .to receive(:send_message)
        .with(chat_id:, **reply_data)

      result
    end

    it "returns success" do
      expect(result).to be_success
    end
  end
end
