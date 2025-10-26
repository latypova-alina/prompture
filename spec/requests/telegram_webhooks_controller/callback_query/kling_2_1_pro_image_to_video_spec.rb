require "rails_helper"
require "telegram/bot/rspec/integration/rails"

describe TelegramWebhooksController, telegram_bot: :rails do
  include_context "telegram/bot/callback_query"
  let(:prompt) { "cute white kitten" }
  let(:data) { "kling_2_1_pro_image_to_video" }
  let(:image_url) { "https://ai-statics.freepik.com/completed_task_image.jpg" }

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

      session["image_url"] = image_url
    end

    context "when callback data is kling_2_1_pro_image_to_video" do
      let(:task_id) { "0a5f0976-011d-411e-abdf-8da8bd07ef9e" }
      let(:expected_markup) do
        {
          inline_keyboard: [
            [{ text: "Kling Pro 2.1 (0.42€)", callback_data: "kling_2_1_pro_image_to_video" }]
          ]
        }
      end
      let(:expected_text) do
        "<a href=\"https://ai-statics.freepik.com/completed_task_video.mp4\">Open video</a>"
      end

      include_context "stub kling success request"

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
        include_context "stub create kling task fail request"

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
        include_context "stub create kling task success request"
        include_context "stub retrieve kling task fail request"

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
        include_context "stub create kling task success request"
        include_context "stub retrieve kling task with FAILED status"

        it "returns error message" do
          expect { dispatch(callback_query:) }
            .to send_telegram_message(bot)
            .with(
              text: "Sorry, I couldn't generate the video. Please try again later.",
              chat_id: 456
            )
        end
      end

      context "when task never completes within max attempts" do
        include_context "stub create kling task success request"
        include_context "stub retrieve kling task with IN_PROGRESS status"

        before do
          allow_any_instance_of(BuildVideo::CheckStatus).to receive(:sleep)
        end

        it "returns error message" do
          expect { dispatch(callback_query:) }
            .to send_telegram_message(bot)
            .with(
              text: "Sorry, the video generation is taking too long. Please try again later.",
              chat_id: 456
            )
        end
      end
    end
  end
end
