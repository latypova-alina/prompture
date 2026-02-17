require "rails_helper"
require "telegram/bot/rspec/integration/rails"

describe TelegramWebhooksController, telegram_bot: :rails do
  include_context "telegram/bot/callback_query"
  let(:prompt) { "cute white kitten" }

  describe "#start!" do
    subject { -> { dispatch_command(:start, token.code) } }

    let(:token) { create(:token) }

    context "when token is correct" do
      let(:expected_text) { "Hello, Rihanna!" }

      it { should respond_with_message(expected_text) }

      context "and token greeting is nil" do
        let(:token) { create(:token, greeting: nil) }

        let(:expected_text) { "Hi there! Please choose a command from the menu list." }

        it { should respond_with_message(expected_text) }
      end
    end

    context "when token is used" do
      let(:token) { create(:token, :used) }

      let(:expected_text) { "Sorry, the token you provided has already been used." }

      it { should respond_with_message(expected_text) }
    end

    context "when token is invalid" do
      subject { -> { dispatch_command(:start, "invalid_token") } }

      let(:expected_text) { "Sorry, the token you provided is invalid. You can ask administrator for a valid token." }

      it { should respond_with_message(expected_text) }
    end

    context "when token is missing" do
      subject { -> { dispatch_command(:start) } }

      let(:expected_text) { "Sorry, the token you provided is invalid. You can ask administrator for a valid token." }

      it { should respond_with_message(expected_text) }
    end

    context "when token is expired" do
      let(:token) { create(:token, :expired) }

      let(:expected_text) { "Sorry, the token you provided has expired." }

      it { should respond_with_message(expected_text) }
    end

    context "when user uses this token again" do
      let(:user) { create(:user, chat_id: 456) }
      let(:token) { create(:token, :used, user:) }
      let(:expected_text) do
        "Hey, seems like you already have an active subscription :) Please choose a command and enjoy the bot!"
      end

      it { should respond_with_message(expected_text) }
    end
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

  describe "#balance", :callback_query do
    let!(:user) { create(:user, :with_balance) }

    let(:expected_text) do
      "Your current balance is 100 credits."
    end

    it_behaves_like "command handling",
                    command: :balance
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
