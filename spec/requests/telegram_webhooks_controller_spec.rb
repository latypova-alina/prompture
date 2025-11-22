require "rails_helper"
require "telegram/bot/rspec/integration/rails"

describe TelegramWebhooksController, telegram_bot: :rails do
  include_context "telegram/bot/callback_query"
  let(:prompt) { "cute white kitten" }

  describe "#start!" do
    subject { -> { dispatch_command :start } }

    let(:expected_text) { "Hi there! Please give a short description of what you want to create. In any language." }

    it { is_expected.to respond_with_message(expected_text) }
  end

  describe "#prompt_to_video!" do
    subject { -> { dispatch_command :prompt_to_video } }

    let(:expected_text) do
      "Great! Now please provide a prompt for the video. The prompt can be in any language and any length, and it can later be adapted with the help of the bot."
    end

    it { is_expected.to respond_with_message(expected_text) }
  end

  describe "#prompt_to_image!" do
    subject { -> { dispatch_command :prompt_to_image } }

    let(:expected_text) do
      "Great! Now please provide a prompt for the image. The prompt can be in any language and any length, and it can later be adapted with the help of the bot."
    end

    it { is_expected.to respond_with_message(expected_text) }
  end

  describe "#message" do
    let(:expected_message) do
      <<~HTML.strip
        Here is your prompt:

        <blockquote>cute white kitten</blockquote>

        What do you want to do next?
      HTML
    end
    let(:expected_markup) do
      {
        inline_keyboard: [
          [{ text: "Extend prompt", callback_data: "extend_prompt" }],
          [{ text: "Gemini (0.035€)", callback_data: "gemini_image" }],
          [{ text: "Imagen3 (0.04€)", callback_data: "imagen_image" }],
          [{ text: "Mystic (0.1€)", callback_data: "mystic_image" }]
        ]
      }
    end

    it "replies with MessagePresenter data" do
      expect { dispatch_message(prompt) }
        .to send_telegram_message(bot)
        .with(
          text: "#{expected_message}\n",
          parse_mode: "HTML",
          reply_markup: expected_markup,
          chat_id: 456
        )
    end
  end

  describe "#callback_query", :callback_query do
    let(:data) { "extend_prompt" }
    let(:session) { FakeSession.new }
    let(:chat_id) { 456 }
    let(:image_url) { "http://example.com/image.png" }

    before do
      allow(Generator::TaskCreatorSelectorJob).to receive(:perform_async)

      allow_any_instance_of(described_class)
        .to receive(:session)
        .and_return(session)

      session["image_prompt"] = prompt
      session["chat_id"] = chat_id
    end

    after { ChatState.del(chat_id, :last_image_url) }

    context "when callback_data is extend_prompt" do
      it "runs TaskCreatorSelectorJob" do
        expect(Generator::TaskCreatorSelectorJob).to receive(:perform_async)
          .with("cute white kitten", nil, "extend_prompt", 456)

        described_class.new.callback_query("extend_prompt")
      end
    end

    context "when callback data is mystic_image" do
      before { ChatState.set(chat_id, :last_image_url, image_url) }

      it "runs TaskCreatorSelectorJob" do
        expect(Generator::TaskCreatorSelectorJob).to receive(:perform_async)
          .with("cute white kitten", "http://example.com/image.png", "mystic_image", 456)

        described_class.new.callback_query("mystic_image")
      end
    end

    context "when callback data is imagen_image" do
      before { ChatState.set(chat_id, :last_image_url, image_url) }

      it "runs TaskCreatorSelectorJob" do
        expect(Generator::TaskCreatorSelectorJob).to receive(:perform_async)
          .with("cute white kitten", "http://example.com/image.png", "imagen_image", 456)

        described_class.new.callback_query("imagen_image")
      end
    end

    context "when callback data is kling_2_1_pro_image_to_video" do
      before { ChatState.set(chat_id, :last_image_url, image_url) }

      it "runs TaskCreatorSelectorJob" do
        expect(Generator::TaskCreatorSelectorJob).to receive(:perform_async)
          .with("cute white kitten", "http://example.com/image.png", "kling_2_1_pro_image_to_video", 456)

        described_class.new.callback_query("kling_2_1_pro_image_to_video")
      end
    end
  end
end
