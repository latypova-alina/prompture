require "rails_helper"

describe StoreImage::TermsGatePresenter do
  subject(:presenter) { described_class.new(record_type:, record_id:, locale:) }

  let(:record_type) { "UserPictureMessage" }
  let(:record_id) { 406 }
  let(:locale) { "en" }

  describe "#reply_data" do
    it "returns HTML parse_mode with the terms gate text and a single agree button" do
      expect(presenter.reply_data).to eq(
        parse_mode: "HTML",
        text: I18n.t(
          "telegram_webhooks.message.terms_gate.prompt",
          privacy_link: '<a href="https://caivemanator.com/privacy_policy">Privacy Policy</a>',
          terms_link: '<a href="https://www.caivemanator.com/terms_of_use">Terms of Use</a>',
          locale:
        ),
        reply_markup: {
          inline_keyboard: [
            [
              {
                text: I18n.t("telegram_webhooks.message.terms_gate.agree_button", locale:),
                callback_data: "accept_terms:UserPictureMessage:406"
              }
            ]
          ]
        }
      )
    end
  end
end
