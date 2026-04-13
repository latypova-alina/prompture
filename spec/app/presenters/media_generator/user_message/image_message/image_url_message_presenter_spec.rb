require "rails_helper"

describe MediaGenerator::UserMessage::ImageMessage::ImageUrlMessagePresenter do
  subject(:presenter) { described_class.new(message: image_url, locale:) }

  let(:image_url) { "https://example.com/image.png" }
  let(:locale) { :en }

  describe "#formatted_text" do
    let(:expected_text) { "#{I18n.t('telegram_webhooks.message.image_message_reply', locale:)}\n" }

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
