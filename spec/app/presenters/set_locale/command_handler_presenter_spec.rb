require "rails_helper"

describe SetLocale::CommandHandlerPresenter do
  subject(:presenter) { described_class.new(locale:) }

  let(:locale) { "es" }

  describe "#formatted_text" do
    it "returns translated text for given locale" do
      expected_text = I18n.t(
        "telegram_webhooks.commands.set_locale.ask",
        locale:
      )

      expect(presenter.formatted_text).to eq(expected_text)
    end
  end

  describe "#inline_keyboard" do
    let(:keyboard) { [[{ text: "es", callback_data: "set_locale:es" }]] }

    before do
      allow(Buttons::ForSetLocale)
        .to receive(:build)
        .and_return(keyboard)
    end

    it "returns keyboard built by Buttons::ForSetLocale" do
      expect(presenter.inline_keyboard).to eq(keyboard)
    end

    it "delegates keyboard building to Buttons::ForSetLocale" do
      presenter.inline_keyboard

      expect(Buttons::ForSetLocale)
        .to have_received(:build)
    end
  end
end
