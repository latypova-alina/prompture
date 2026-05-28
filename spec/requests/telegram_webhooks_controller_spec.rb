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
    let!(:user) { create(:user, :with_balance, chat_id: 456) }

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

  describe "#prompt_to_audio!" do
    let(:expected_text) do
      "Great! Now please provide a prompt for the audio."
    end

    it_behaves_like "command handling",
                    command: :prompt_to_audio
  end

  describe "#image_to_video!" do
    let(:expected_text) do
      I18n.t("telegram_webhooks.commands.image_to_video")
    end

    it_behaves_like "command handling",
                    command: :image_to_video
  end

  describe "#random_script!" do
    subject { -> { dispatch_command(:random_script) } }

    let!(:user) { create(:user, chat_id: 456, admin:) }
    let(:admin) { true }

    before do
      allow(ScriptGenerator::GenerateScriptJob).to receive(:perform_async)
    end

    it "enqueues random script generation job" do
      subject.call

      expect(ScriptGenerator::GenerateScriptJob).to have_received(:perform_async).with(456, nil)
    end

    it { should respond_with_message("Started script generation.") }

    context "when user is not admin" do
      let(:admin) { false }

      it { should respond_with_message(I18n.t("errors.admin_only_command")) }
    end
  end

  %w[en pl ru].each do |language|
    describe "#motivation_workflow_#{language}!" do
      subject { -> { dispatch_command(:"motivation_workflow_#{language}") } }

      let!(:user) { create(:user, chat_id: 456, admin:) }
      let(:admin) { true }

      before do
        allow(ScriptGenerator::ForMotivation::GenerateMotivationWorkflowJob).to receive(:perform_async)
      end

      it "enqueues motivation workflow job with language" do
        subject.call

        expect(ScriptGenerator::ForMotivation::GenerateMotivationWorkflowJob)
          .to have_received(:perform_async).with(456, language)
      end

      it { should respond_with_message(I18n.t("telegram_webhooks.commands.motivation_workflow")) }

      context "when user is not admin" do
        let(:admin) { false }

        it { should respond_with_message(I18n.t("errors.admin_only_command")) }
      end
    end
  end

  describe "#generate_script!" do
    subject { -> { dispatch_command(:generate_script, "daily_news") } }

    let!(:user) { create(:user, chat_id: 456, admin:) }
    let(:admin) { true }

    before do
      allow(ScriptGenerator::GenerateScript).to receive(:call).and_return(double(failure?: false))
    end

    it "calls script generation flow" do
      subject.call

      expect(ScriptGenerator::GenerateScript).to have_received(:call).with(
        chat_id: 456,
        message_body: hash_including("message" => hash_including("text" => "/generate_script daily_news"))
      )
    end

    it { should respond_with_message("Started script generation.") }

    context "when user is not admin" do
      let(:admin) { false }

      it { should respond_with_message(I18n.t("errors.admin_only_command")) }
    end
  end

  describe "#script_templates!" do
    subject { -> { dispatch_command(:script_templates) } }

    let!(:user) { create(:user, chat_id: 456, admin:) }
    let(:admin) { true }

    before do
      allow(ScriptGenerator::SendScriptTemplatesJob).to receive(:perform_async)
    end

    it { is_expected.to respond_with_message("Fetching script templates.") }

    it "enqueues templates sending job" do
      subject.call

      expect(ScriptGenerator::SendScriptTemplatesJob).to have_received(:perform_async).with(456)
    end

    context "when user is not admin" do
      let(:admin) { false }

      it { is_expected.to respond_with_message(I18n.t("errors.admin_only_command")) }
    end
  end

  describe "#random_character!" do
    subject { -> { dispatch_command(:random_character) } }

    let!(:user) { create(:user, chat_id: 456, admin:) }
    let(:admin) { true }

    before do
      allow(ScriptGenerator::ProcessRandomCharacterJob).to receive(:perform_async)
    end

    it { is_expected.to respond_with_message(I18n.t("telegram_webhooks.commands.random_character")) }

    it "enqueues random character job" do
      subject.call

      expect(ScriptGenerator::ProcessRandomCharacterJob).to have_received(:perform_async).with(456)
    end

    context "when user is not admin" do
      let(:admin) { false }

      it { is_expected.to respond_with_message(I18n.t("errors.admin_only_command")) }
    end
  end

  describe "#brainrot_character!" do
    subject { -> { dispatch_command(:brainrot_character) } }

    let!(:user) { create(:user, chat_id: 456, admin:) }
    let(:admin) { true }

    before do
      allow(ScriptGenerator::ProcessBrainrotCharacterJob).to receive(:perform_async)
    end

    it { is_expected.to respond_with_message(I18n.t("telegram_webhooks.commands.brainrot_character")) }

    it "enqueues brainrot character job" do
      subject.call

      expect(ScriptGenerator::ProcessBrainrotCharacterJob).to have_received(:perform_async).with(456)
    end

    context "when user is not admin" do
      let(:admin) { false }

      it { is_expected.to respond_with_message(I18n.t("errors.admin_only_command")) }
    end
  end

  describe "#admin!" do
    subject { -> { dispatch_command(:admin) } }

    let!(:user) { create(:user, chat_id: 456, admin:) }
    let(:admin) { true }

    it { is_expected.to respond_with_message(I18n.t("telegram_webhooks.commands.admin")) }

    context "when user is not admin" do
      let(:admin) { false }

      it { is_expected.to respond_with_message(I18n.t("errors.admin_only_command")) }
    end
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

  describe "#flux_image_callback_query", :callback_query do
    it_behaves_like "an image callback",
                    processor: "flux",
                    record_creator: RecordCreators::ButtonRequests::Images::Flux,
                    job_class: ::Generator::Media::Image::TaskCreatorJob
  end

  describe "#nano_banana_image_callback_query", :callback_query do
    it_behaves_like "an image callback",
                    processor: "nano_banana",
                    record_creator: RecordCreators::ButtonRequests::Images::NanoBanana,
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

  describe "#wan_video_callback_query", :callback_query do
    it_behaves_like "a video callback",
                    processor: "wan_2_2",
                    record_creator: RecordCreators::ButtonRequests::Videos::Wan,
                    job_class: ::Generator::Media::Video::TaskCreatorJob
  end

  describe "#set_locale_callback_query", :callback_query do
    it_behaves_like "set_locale callback"
  end
end
