require "rails_helper"
require "telegram/bot/rspec/integration/rails"

describe TelegramWebhooksController, telegram_bot: :rails do
  include_context "telegram/bot/callback_query"
  let(:prompt) { "cute white kitten" }
  let(:data) { "extend_prompt" }

  describe "#callback_query", :callback_query do
    let(:session) { FakeSession.new }
    let(:callback_query) do
      {
        id: "123",
        from:,
        message: { chat: chat, message_id: 5, text: prompt },
        data: data
      }
    end

    before do
      allow_any_instance_of(described_class)
        .to receive(:session)
        .and_return(session)

      session["image_prompt"] = prompt
    end

    context "when callback_data is extend_prompt" do
      let(:expected_markup) do
        {
          inline_keyboard: [
            [{ text: "Gemini (0.035€)", callback_data: "gemini_image" }],
            [{ text: "Imagen3 (0.04€)", callback_data: "imagen_image" }],
            [{ text: "Mystic (0.1€)", callback_data: "mystic_image" }]
          ]
        }
      end

      include_context "stub chat_gpt success request"

      it "returns correct response" do
        expect { dispatch(callback_query:) }
          .to send_telegram_message(bot)
          .with(
            text: "simulated GPT text",
            parse_mode: "HTML",
            reply_markup: expected_markup,
            chat_id: 456
          )
      end

      context "and chatgpt response is error" do
        include_context "stub chat_gpt error request"

        it "returns error message" do
          expect { dispatch(callback_query:) }
            .to send_telegram_message(bot)
            .with(
              text: "Sorry, I couldn't process your request. Please try again later.",
              chat_id: 456
            )
        end
      end
    end
  end
end
