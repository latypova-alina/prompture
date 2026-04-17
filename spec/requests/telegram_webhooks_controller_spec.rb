require "rails_helper"
require "telegram/bot/rspec/integration/rails"

describe TelegramWebhooksController, telegram_bot: :rails do
  include_context "telegram/bot/callback_query"
  let(:prompt) { "cute white kitten" }

  describe "#start!" do
    subject { -> { dispatch_command(:start, token.code) } }

    let(:token) { create(:token) }

    context "when token is correct" do
      let(:expected_greeting_text) do
        "Hello, Rihanna!\n\n✅ Your token has been successfully activated!\n\n🎉 You have received 100 credits.\n"
      end

      let(:expected_default_text) do
        I18n.t(
          "telegram_webhooks.commands.start.with_valid_token",
          credits: 100
        )
      end

      it { should respond_with_message(expected_greeting_text) }
      it { should respond_with_message(expected_default_text) }

      context "and token greeting is nil" do
        let(:token) { create(:token, greeting: nil) }

        it { should respond_with_message(expected_default_text) }
      end
    end

    context "when token is invalid" do
      let(:expected_text) do
        I18n.t(
          "telegram_webhooks.commands.start.no_token",
          credits: 100
        )
      end

      context "when token is used" do
        let(:token) { create(:token, :used) }

        it { should respond_with_message(expected_text) }
      end

      context "when token is invalid" do
        subject { -> { dispatch_command(:start, "invalid_token") } }

        it { should respond_with_message(expected_text) }
      end

      context "when token is missing" do
        subject { -> { dispatch_command(:start) } }

        it { should respond_with_message(expected_text) }
      end

      context "when token is expired" do
        let(:token) { create(:token, :expired) }

        it { should respond_with_message(expected_text) }
      end
    end
  end

  describe "#activate_token!" do
    subject { -> { dispatch_command(:activate_token) } }

    let(:expected_text) do
      "Please enter your token to activate it:"
    end

    it { should respond_with_message(expected_text) }
  end

  describe "#help!" do
    subject { -> { dispatch_command(:help) } }

    let(:expected_text) do
      I18n.t("telegram_webhooks.commands.help")
    end

    it { should respond_with_message(expected_text) }
  end

  describe "#prompt_policy!" do
    subject { -> { dispatch_command(:prompt_policy) } }

    let(:expected_text) do
      I18n.t("telegram_webhooks.commands.prompt_policy")
    end

    it_behaves_like "command handling",
                    command: :prompt_policy
  end

  describe "#set_locale!" do
    subject { -> { dispatch_command(:set_locale) } }

    let(:expected_text) do
      "Please select your preferred language:"
    end

    it_behaves_like "command handling",
                    command: :set_locale
  end

  describe "#prompt_to_video!" do
    let(:expected_text) do
      "Great! Now please provide a prompt for the video. It can later be extended with the help of the bot."
    end

    it_behaves_like "command handling",
                    command: :prompt_to_video
  end

  describe "#prompt_to_image!" do
    let(:expected_text) do
      "Great! Now please provide a prompt for the image. It can later be extended with the help of the bot."
    end

    it_behaves_like "command handling",
                    command: :prompt_to_image
  end

  describe "#image_to_video!" do
    let(:expected_text) do
      I18n.t("telegram_webhooks.commands.image_to_video")
    end

    it_behaves_like "command handling",
                    command: :image_to_video
  end

  describe "#message" do
    let(:user_message) { dispatch_message(prompt) }

    subject { -> { user_message } }

    it_behaves_like "message handling"
  end

  describe "#balance", :callback_query do
    let(:expected_text) do
      "Your current balance is 100 credits."
    end

    it_behaves_like "command handling",
                    command: :balance
  end

  describe "#extend_prompt_callback_query", :callback_query do
    context "when improve_prompt_with_freepik is enabled for user" do
      before do
        allow(Flipper[:improve_prompt_with_freepik]).to receive(:enabled?).and_return(true)
      end

      it_behaves_like "extend prompt callback",
                      record_creator: RecordCreators::ButtonRequests::ExtendPrompt,
                      job_class: ::Generator::Media::Prompt::TaskCreatorJob
    end

    context "when improve_prompt_with_freepik is disabled for user" do
      before do
        allow(Flipper[:improve_prompt_with_freepik]).to receive(:enabled?).and_return(false)
      end

      it_behaves_like "extend prompt callback",
                      record_creator: RecordCreators::ButtonRequests::ExtendPrompt,
                      job_class: ::Generator::Prompt::ExtendJob
    end
  end

  describe "#mystic_image_callback_query", :callback_query do
    it_behaves_like "an image callback",
                    processor: "mystic",
                    record_creator: RecordCreators::ButtonRequests::Images::Mystic,
                    job_class: ::Generator::Media::Image::TaskCreatorJob
  end

  describe "#flux_image_callback_query", :callback_query do
    it_behaves_like "an image callback",
                    processor: "flux",
                    record_creator: RecordCreators::ButtonRequests::Images::Flux,
                    job_class: ::Generator::Media::Image::TaskCreatorJob
  end

  describe "#gemini_image_callback_query", :callback_query do
    it_behaves_like "an image callback",
                    processor: "gemini",
                    record_creator: RecordCreators::ButtonRequests::Images::Gemini,
                    job_class: ::Generator::Media::Image::TaskCreatorJob
  end

  describe "#imagen_image_callback_query", :callback_query do
    it_behaves_like "an image callback",
                    processor: "imagen",
                    record_creator: RecordCreators::ButtonRequests::Images::Imagen,
                    job_class: ::Generator::Media::Image::TaskCreatorJob
  end

  describe "#kling_video_callback_query", :callback_query do
    it_behaves_like "a video callback",
                    processor: "kling_2_1_pro",
                    record_creator: RecordCreators::ButtonRequests::Videos::Kling,
                    job_class: ::Generator::Media::Video::TaskCreatorJob
  end

  describe "#seedance_video_callback_query", :callback_query do
    it_behaves_like "a video callback",
                    processor: "seedance_1_5_pro",
                    record_creator: RecordCreators::ButtonRequests::Videos::Seedance,
                    job_class: ::Generator::Media::Video::TaskCreatorJob
  end

  describe "#set_locale_callback_query", :callback_query do
    it_behaves_like "set_locale callback"
  end
end
