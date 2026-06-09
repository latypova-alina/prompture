require "rails_helper"

describe MediaGenerator::UserMessage::ImageMessage::PictureMessagePresenter do
  subject(:presenter) { described_class.new(locale:) }

  let(:locale) { :en }

  describe "#formatted_text" do
    let(:expected_text) do
      <<~HTML
        #{I18n.t('telegram_webhooks.message.image_to_video_image_reply', locale:)}
      HTML
    end

    it "returns formatted picture message text" do
      expect(presenter.formatted_text).to eq(expected_text)
    end
  end

  describe "#inline_keyboard" do
    let(:expected_buttons) do
      [
        [{ callback_data: "provide_prompt", text: "Provide Prompt" }],
        [{ callback_data: "kling_2_1_pro_image_to_video",
           text: "Kling Pro 2.1 (10 credits)" }],
        [{ callback_data: "seedance_2_0_image_to_video",
           text: "Seedance 2.0 (6 credits)" }]
      ]
    end

    it "returns image-to-video buttons for locale" do
      expect(presenter.inline_keyboard).to eq(expected_buttons)
    end
  end
end
