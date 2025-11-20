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

  describe "#message" do
    let(:expected_message) do
      <<~TEXT.strip
        Here is your prompt:

        cute white kitten

        What do you want to do next?
      TEXT
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
