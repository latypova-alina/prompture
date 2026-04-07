require "rails_helper"

describe MediaGenerator::UserMessagePresenters::ImageMessagePresenter do
  subject(:presenter) { described_class.new(message: image_url, locale:) }

  let(:image_url) { "https://example.com/image.png" }
  let(:locale) { :en }

  describe "#formatted_text" do
    let(:expected_text) do
      <<~HTML
        <a href="#{image_url}">#{I18n.t("telegram_webhooks.message.image_message_url", locale:)}</a>

        #{I18n.t("telegram_webhooks.message.image_message_reply", locale:)}
      HTML
    end

    it "returns formatted image url text" do
      expect(presenter.formatted_text).to eq(expected_text)
    end
  end

  describe "#inline_keyboard" do
    let(:buttons) { [[{ text: "Animate", callback_data: "image_to_video" }]] }

    before do
      allow(Buttons::ForImageMessage::ForImageToVideo)
        .to receive(:build)
        .with(locale:)
        .and_return(buttons)
    end

    it "returns image-to-video buttons for locale" do
      expect(presenter.inline_keyboard).to eq(buttons)
    end
  end
end
