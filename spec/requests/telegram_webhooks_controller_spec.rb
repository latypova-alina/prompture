require "rails_helper"
require "telegram/bot/rspec/integration/rails"

describe TelegramWebhooksController, telegram_bot: :rails do
  include_context "telegram/bot/callback_query"
  let(:prompt) { "cute white kitten" }

  describe "#start!" do
    let(:expected_text) { "Hi there! Please choose a command from the menu list." }

    it_behaves_like "command handling",
                    command: :start
  end

  describe "#prompt_to_video!" do
    let(:expected_text) do
      "Great! Now please provide a prompt for the video. The prompt can be in any language and any length, " \
      "and it can later be adapted with the help of the bot."
    end

    it_behaves_like "command handling",
                    command: :prompt_to_video
  end

  describe "#prompt_to_image!" do
    let(:expected_text) do
      "Great! Now please provide a prompt for the image. The prompt can be in any language and any length, " \
      "and it can later be adapted with the help of the bot."
    end

    it_behaves_like "command handling",
                    command: :prompt_to_image
  end

  describe "#message" do
    subject { -> { dispatch_message(prompt) } }

    it_behaves_like "message handling"
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
