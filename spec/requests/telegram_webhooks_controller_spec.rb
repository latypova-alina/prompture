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

    context "when callback data is mystic_image" do
      let(:data) { "mystic_image" }
      let(:task_id) { "0a5f0976-011d-411e-abdf-8da8bd07ef9e" }
      let(:expected_markup) do
        {
          inline_keyboard: [
            [{ text: "Gemini (0.035€)", callback_data: "gemini_image" }],
            [{ text: "Imagen3 (0.04€)", callback_data: "imagen_image" }],
            [{ text: "Mystic (0.1€)", callback_data: "mystic_image" }],
            [{ text: "Kling Pro 2.1 (0.42€)", callback_data: "kling_2_1_pro_image_to_video" }]
          ]
        }
      end
      let(:expected_text) do
        "<a href=\"https://ai-statics.freepik.com/completed_task_image.jpg\">Open image</a>"
      end

      include_context "stub mystic success request"

      it "returns correct response" do
        expect { dispatch(callback_query:) }
          .to send_telegram_message(bot)
          .with(
            text: expected_text,
            parse_mode: "HTML",
            reply_markup: expected_markup,
            chat_id: 456
          )
      end

      context "but task creation failed" do
        include_context "stub create mystic task fail request"

        it "returns error message" do
          expect { dispatch(callback_query:) }
            .to send_telegram_message(bot)
            .with(
              text: "Sorry, I couldn't process your request. Please try again later.",
              chat_id: 456
            )
        end
      end

      context "but task retrieval failed" do
        include_context "stub create mystic task success request"
        include_context "stub retrieve mystic task fail request"

        it "returns error message" do
          expect { dispatch(callback_query:) }
            .to send_telegram_message(bot)
            .with(
              text: "Sorry, I couldn't process your request. Please try again later.",
              chat_id: 456
            )
        end
      end

      context "but task retrieved task has FAILED status" do
        include_context "stub create mystic task success request"
        include_context "stub retrieve mystic task with FAILED status"

        it "returns error message" do
          expect { dispatch(callback_query:) }
            .to send_telegram_message(bot)
            .with(
              text: "Sorry, I couldn't generate the image. Please try again later.",
              chat_id: 456
            )
        end
      end

      context "when task never completes within max attempts" do
        include_context "stub create mystic task success request"
        include_context "stub retrieve mystic task with IN_PROGRESS status"

        before do
          allow_any_instance_of(BuildImage::CheckStatus).to receive(:sleep)
        end

        it "returns error message" do
          expect { dispatch(callback_query:) }
            .to send_telegram_message(bot)
            .with(
              text: "Sorry, the image generation is taking too long. Please try again later.",
              chat_id: 456
            )
        end
      end
    end
  end
end
