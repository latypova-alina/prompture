require "rails_helper"

describe SetLocale::ButtonHandler::NotifyUser do
  subject(:result) { described_class.call(chat_id:, selected_locale:) }

  let(:chat_id) { 456 }
  let(:selected_locale) { "es" }

  let(:bot) { instance_double(Telegram::Bot::Client) }

  let(:translated_text) do
    I18n.t(
      "telegram_webhooks.commands.set_locale.locale_updated",
      locale: selected_locale
    )
  end

  before do
    allow(Telegram).to receive(:bot).and_return(bot)
    allow(bot).to receive(:send_message)
  end

  describe ".call" do
    it "calls Telegram.bot.send_message with correct arguments" do
      expect(bot)
        .to receive(:send_message)
        .with(
          chat_id:,
          text: translated_text
        )

      result
    end

    it "returns success" do
      expect(result).to be_success
    end
  end
end
