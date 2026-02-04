require "rails_helper"
require "telegram/bot/rspec/integration/rails"

describe TelegramWebhooksController, telegram_bot: :rails do
  include_context "telegram/bot/callback_query"
  let(:prompt) { "cute white kitten" }

  describe "#start!" do
    subject { -> { dispatch_command :start } }

    let(:expected_text) { "Hi there! Please choose a command from the menu list." }

    it { is_expected.to respond_with_message(expected_text) }
  end

  describe "#prompt_to_video!" do
    subject { -> { dispatch_command :prompt_to_video } }

    let(:expected_text) do
      "Great! Now please provide a prompt for the video. The prompt can be in any language and any length, " \
      "and it can later be adapted with the help of the bot."
    end

    it { is_expected.to respond_with_message(expected_text) }
  end

  describe "#prompt_to_image!" do
    subject { -> { dispatch_command :prompt_to_image } }

    let(:expected_text) do
      "Great! Now please provide a prompt for the image. The prompt can be in any language and any length, " \
      "and it can later be adapted with the help of the bot."
    end

    it { is_expected.to respond_with_message(expected_text) }
  end

  describe "#message" do
    subject { -> { dispatch_message(prompt) } }

    context "when command was not selected" do
      let(:expected_text) do
        "Oops! It looks like you haven’t selected a command yet. Please choose one and follow the instructions."
      end

      it { is_expected.to respond_with_message(expected_text) }
    end

    context "when command is known" do
      include_context "telegram callback setup"

      before { setup_parent_message }

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
  end

  describe "#extend_prompt_callback_query", :callback_query do
    it_behaves_like "extend prompt callback",
                    record_creator: RecordCreators::ButtonRequests::ExtendPrompt,
                    job_class: ::Generator::Prompt::ExtendJob
  end

  describe "#mystic_image_callback_query", :callback_query do
    it_behaves_like "an image callback",
                    processor: "mystic",
                    record_creator: RecordCreators::ButtonRequests::Images::Mystic,
                    job_class: ::Generator::Image::Mystic::TaskCreatorJob
  end

  describe "#mystic_image_callback_query", :callback_query do
    it_behaves_like "an image callback",
                    processor: "mystic",
                    record_creator: RecordCreators::ButtonRequests::Images::Mystic,
                    job_class: ::Generator::Image::Mystic::TaskCreatorJob
  end

  describe "#gemini_image_callback_query", :callback_query do
    it_behaves_like "an image callback",
                    processor: "gemini",
                    record_creator: RecordCreators::ButtonRequests::Images::Gemini,
                    job_class: ::Generator::Image::Gemini::TaskCreatorJob
  end

  describe "#imagen_image_callback_query", :callback_query do
    it_behaves_like "an image callback",
                    processor: "imagen",
                    record_creator: RecordCreators::ButtonRequests::Images::Imagen,
                    job_class: ::Generator::Image::Imagen::TaskCreatorJob
  end

  describe "#kling_video_callback_query", :callback_query do
    it_behaves_like "a video callback",
                    processor: "kling_2_1_pro",
                    record_creator: RecordCreators::ButtonRequests::Videos::Kling,
                    job_class: ::Generator::Video::Kling::TaskCreatorJob
  end
end
