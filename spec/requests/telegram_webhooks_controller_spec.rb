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
        "Hello, Rihanna!\n\n✅ Your token has been successfully activated!\n\n🎉 You have received 100 inks 🖋️.\n"
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

        it "still creates a user" do
          expect { subject.call }.to change(User, :count).by(1)
        end
      end

      context "when token is invalid" do
        subject { -> { dispatch_command(:start, "invalid_token") } }

        it { should respond_with_message(expected_text) }

        it "still creates a user" do
          expect { subject.call }.to change(User, :count).by(1)
        end
      end

      context "when token is missing" do
        subject { -> { dispatch_command(:start) } }

        it { should respond_with_message(expected_text) }

        it "still creates a user" do
          expect { subject.call }.to change(User, :count).by(1)
        end
      end

      context "when token is expired" do
        let(:token) { create(:token, :expired) }

        it { should respond_with_message(expected_text) }

        it "still creates a user" do
          expect { subject.call }.to change(User, :count).by(1)
        end
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

    context "when chat is authorized" do
      let!(:user) { create(:user, :with_balance, chat_id: 456) }

      it { should respond_with_message(expected_text) }
    end

    context "when chat is not authorized" do
      let(:chat_id) { 999 }

      it { should respond_with_message(expected_text) }
    end
  end

  describe "#prompt_policy!" do
    subject { -> { dispatch_command(:prompt_policy) } }

    let(:expected_text) do
      I18n.t("telegram_webhooks.commands.prompt_policy")
    end

    context "when chat is authorized" do
      let!(:user) { create(:user, :with_balance, chat_id: 456) }

      it { should respond_with_message(expected_text) }
    end

    context "when chat is not authorized" do
      let(:chat_id) { 999 }

      it { should respond_with_message(expected_text) }
    end
  end

  describe "#contact_support!" do
    subject { -> { dispatch_command(:contact_support) } }

    let(:expected_text) do
      I18n.t(
        "telegram_webhooks.commands.contact_support",
        support_email: Rails.application.config.x.support_email
      )
    end

    context "when chat is authorized" do
      let!(:user) { create(:user, :with_balance, chat_id: 456) }

      it { should respond_with_message(expected_text) }
    end

    context "when chat is not authorized" do
      let(:chat_id) { 999 }

      it { should respond_with_message(expected_text) }
    end
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

  describe "#first_last_frame_to_video!" do
    let(:expected_text) do
      I18n.t("telegram_webhooks.commands.first_last_frame_to_video")
    end

    it_behaves_like "command handling",
                    command: :first_last_frame_to_video
  end

  describe "#generate_random_cats_script!" do
    subject { -> { dispatch_command(:generate_random_cats_script) } }

    let!(:user) { create(:user, chat_id: 456, admin:) }
    let(:admin) { true }

    before do
      allow(ScriptGenerator::ForCats::GenerateScriptJob).to receive(:perform_async)
    end

    it "enqueues random script generation job" do
      subject.call

      expect(ScriptGenerator::ForCats::GenerateScriptJob).to have_received(:perform_async).with(456, nil)
    end

    it { should respond_with_message("Started script generation.") }

    context "when user is not admin" do
      let(:admin) { false }

      it { should_not respond_with_message }
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

        it { should_not respond_with_message }
      end
    end
  end

  describe "#generate_cats_script!" do
    subject { -> { dispatch_command(:generate_cats_script, "daily_news") } }

    let!(:user) { create(:user, chat_id: 456, admin:) }
    let(:admin) { true }

    before do
      allow(ScriptGenerator::ForCats::Generate).to receive(:call).and_return(double(failure?: false))
    end

    it "calls script generation flow" do
      subject.call

      expect(ScriptGenerator::ForCats::Generate).to have_received(:call).with(
        chat_id: 456,
        message_body: hash_including("message" => hash_including("text" => "/generate_cats_script daily_news"))
      )
    end

    it { should respond_with_message("Started script generation.") }

    context "when user is not admin" do
      let(:admin) { false }

      it { should_not respond_with_message }
    end
  end

  describe "#cats_script_templates!" do
    subject { -> { dispatch_command(:cats_script_templates) } }

    let!(:user) { create(:user, chat_id: 456, admin:) }
    let(:admin) { true }

    before do
      allow(ScriptGenerator::ForCats::SendScriptTemplatesJob).to receive(:perform_async)
    end

    it { is_expected.to respond_with_message("Fetching script templates.") }

    it "enqueues templates sending job" do
      subject.call

      expect(ScriptGenerator::ForCats::SendScriptTemplatesJob).to have_received(:perform_async).with(456)
    end

    context "when user is not admin" do
      let(:admin) { false }

      it { is_expected.not_to respond_with_message }
    end
  end

  describe "#food_character!" do
    subject { -> { dispatch_command(:food_character) } }

    let!(:user) { create(:user, chat_id: 456, admin:) }
    let(:admin) { true }

    before do
      allow(ScriptGenerator::Process::RandomCharacterJob).to receive(:perform_async)
    end

    it { is_expected.to respond_with_message(I18n.t("telegram_webhooks.commands.food_character")) }

    it "enqueues random character job" do
      subject.call

      expect(ScriptGenerator::Process::RandomCharacterJob).to have_received(:perform_async).with(456)
    end

    context "when user is not admin" do
      let(:admin) { false }

      it { is_expected.not_to respond_with_message }
    end
  end

  describe "#brainrot_character!" do
    subject { -> { dispatch_command(:brainrot_character) } }

    let!(:user) { create(:user, chat_id: 456, admin:) }
    let(:admin) { true }

    before do
      allow(ScriptGenerator::Process::BrainrotCharacterJob).to receive(:perform_async)
    end

    it { is_expected.to respond_with_message(I18n.t("telegram_webhooks.commands.brainrot_character")) }

    it "enqueues brainrot character job" do
      subject.call

      expect(ScriptGenerator::Process::BrainrotCharacterJob).to have_received(:perform_async).with(456)
    end

    context "when user is not admin" do
      let(:admin) { false }

      it { is_expected.not_to respond_with_message }
    end
  end

  describe "#bloomy_multiscene_cartoon_yt!" do
    subject { -> { dispatch_command(:bloomy_multiscene_cartoon_yt) } }

    let!(:user) { create(:user, chat_id: 456, admin:) }
    let(:admin) { true }

    before do
      allow(ScriptGenerator::Process::ForBloomy::MultiSceneScriptJob).to receive(:perform_async)
    end

    it { is_expected.to respond_with_message(I18n.t("telegram_webhooks.commands.bloomy_multiscene_cartoon_yt")) }

    it "enqueues cartoon script job" do
      subject.call

      expect(ScriptGenerator::Process::ForBloomy::MultiSceneScriptJob).to have_received(:perform_async).with(456)
    end

    context "when user is not admin" do
      let(:admin) { false }

      it { is_expected.not_to respond_with_message }
    end
  end

  describe "#bloomy_cartoon_short!" do
    subject { -> { dispatch_command(:bloomy_cartoon_short) } }

    let!(:user) { create(:user, chat_id: 456, admin:) }
    let(:admin) { true }

    before do
      allow(ScriptGenerator::Process::ForBloomy::SingleScriptJob).to receive(:perform_async)
    end

    it { is_expected.to respond_with_message(I18n.t("telegram_webhooks.commands.bloomy_cartoon_short")) }

    it "enqueues single cartoon script job with shorts category" do
      subject.call

      expect(ScriptGenerator::Process::ForBloomy::SingleScriptJob).to have_received(:perform_async).with(
        456,
        ContentCategory::CARTOON_BLOOMY_SHORTS_SCRIPT
      )
    end

    context "when user is not admin" do
      let(:admin) { false }

      it { is_expected.not_to respond_with_message }
    end
  end

  describe "#cartoon_character!" do
    subject { -> { dispatch_command(:cartoon_character) } }

    let!(:user) { create(:user, chat_id: 456, admin:) }
    let(:admin) { true }

    before do
      allow(ScriptGenerator::Process::CartoonCharacterJob).to receive(:perform_async)
    end

    it { is_expected.to respond_with_message(I18n.t("telegram_webhooks.commands.cartoon_character")) }

    it "enqueues cartoon character job" do
      subject.call

      expect(ScriptGenerator::Process::CartoonCharacterJob).to have_received(:perform_async).with(456)
    end

    context "when user is not admin" do
      let(:admin) { false }

      it { is_expected.not_to respond_with_message }
    end
  end

  describe "#admin!" do
    subject { -> { dispatch_command(:admin) } }

    let!(:user) { create(:user, chat_id: 456, admin:) }
    let(:admin) { true }

    it { is_expected.to respond_with_message(I18n.t("telegram_webhooks.commands.admin")) }

    context "when user is not admin" do
      let(:admin) { false }

      it { is_expected.not_to respond_with_message }
    end
  end

  describe "#message" do
    let(:user_message) { dispatch_message(prompt) }

    subject { -> { user_message } }

    it_behaves_like "message handling"
  end

  describe "#buy_inks!" do
    subject { -> { dispatch_command(:buy_inks) } }

    context "when the feature is enabled" do
      before { Flipper.enable(:stars_payments) }

      let(:expected_text) { I18n.t("telegram_webhooks.commands.buy_inks.ask") }

      it_behaves_like "command handling", command: :buy_inks
    end

    context "when the feature is disabled" do
      let!(:user) { create(:user, :with_balance, chat_id: 456) }

      it { should respond_with_message(I18n.t("errors.feature_under_development")) }
    end
  end

  describe "#pre_checkout_query" do
    let(:pack_key) { "medium" }
    let(:pack) { CREDIT_PACKS[:medium] }
    let!(:user) { create(:user, chat_id: from_id) }

    let(:update) do
      {
        update_id: 1,
        pre_checkout_query: {
          id: "pcq_1",
          from: { id: from_id },
          currency: "XTR",
          total_amount: pack[:stars],
          invoice_payload: pack_key
        }
      }
    end

    context "when the pack exists" do
      it "approves the checkout" do
        expect { dispatch(update) }
          .to make_telegram_request(bot, :answerPreCheckoutQuery)
          .with(pre_checkout_query_id: "pcq_1", ok: true)
      end
    end

    context "when the pack does not exist" do
      let(:pack_key) { "unknown" }

      it "rejects the checkout" do
        expect { dispatch(update) }
          .to make_telegram_request(bot, :answerPreCheckoutQuery)
          .with(pre_checkout_query_id: "pcq_1", ok: false, error_message: I18n.t("errors.pack_not_found"))
      end
    end

    context "when the user does not exist" do
      let(:user) { nil }

      it "rejects the checkout instead of crashing" do
        expect { dispatch(update) }
          .to make_telegram_request(bot, :answerPreCheckoutQuery)
          .with(pre_checkout_query_id: "pcq_1", ok: false, error_message: I18n.t("errors.unauthorized"))
      end
    end
  end

  describe "#message with successful_payment" do
    let(:pack_key) { "medium" }
    let(:pack) { CREDIT_PACKS[:medium] }
    let(:telegram_payment_charge_id) { "charge_abc" }

    let(:update) do
      {
        update_id: 1,
        message: {
          message_id: 10,
          date: Time.current.to_i,
          chat: { id: chat_id, first_name: "Barbara" },
          from: { id: from_id, first_name: "Barbara" },
          successful_payment: {
            currency: "XTR",
            total_amount: pack[:stars],
            invoice_payload: pack_key,
            telegram_payment_charge_id:,
            provider_payment_charge_id: ""
          }
        }
      }
    end

    it "grants the pack's credits to the user" do
      dispatch(update)

      expect(User.find_by(chat_id:).balance.credits).to eq(pack[:credits])
    end

    it "creates a StarsPurchase record" do
      expect { dispatch(update) }.to change(StarsPurchase, :count).by(1)
    end

    it "sends a thank you message" do
      expected_text = I18n.t(
        "telegram_webhooks.commands.buy_inks.thank_you",
        credits: pack[:credits],
        count: pack[:credits]
      )

      expect { dispatch(update) }
        .to send_telegram_message(bot, expected_text, chat_id:)
    end

    context "when the same payment update is delivered twice" do
      it "does not grant credits twice" do
        dispatch(update)

        expect { dispatch(update) }.not_to(change { User.find_by(chat_id:).balance.credits })
      end

      it "does not create a duplicate StarsPurchase" do
        dispatch(update)

        expect { dispatch(update) }.not_to change(StarsPurchase, :count)
      end
    end
  end

  describe "#balance", :callback_query do
    let(:expected_text) do
      "Your current balance is 100 inks 🖋️."
    end

    it_behaves_like "command handling",
                    command: :balance
  end

  describe "#extend_prompt_callback_query", :callback_query do
    it_behaves_like "extend prompt callback",
                    record_creator: RecordCreators::ButtonRequests::ExtendPrompt,
                    job_class: ::Generator::Prompt::ExtendJob
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

  describe "#kling_video_callback_query", :callback_query do
    it_behaves_like "a video callback",
                    processor: "kling_2_1_pro",
                    record_creator: RecordCreators::ButtonRequests::Videos::Kling
  end

  describe "#hailuo_02_standard_video_callback_query", :callback_query do
    it_behaves_like "a video callback",
                    processor: "hailuo_02_standard",
                    record_creator: RecordCreators::ButtonRequests::Videos::Hailuo02Standard
  end

  describe "#veo3_1_lite_video_callback_query", :callback_query do
    it_behaves_like "a video callback",
                    processor: "veo3_1_lite",
                    record_creator: RecordCreators::ButtonRequests::Videos::Veo31Lite
  end

  describe "#set_locale_callback_query", :callback_query do
    it_behaves_like "set_locale callback"
  end
end
