require "rails_helper"
require "telegram/bot/rspec/integration/rails"

# A user at 0 stones gets the insufficient-stones reply - plus the "🛒 Open Store" button while the
# stars payments feature is enabled for them - for both button taps and plain messages.
describe TelegramWebhooksController, telegram_bot: :rails do
  subject(:sent_message) do
    dispatch(update)
    bot.requests[:sendMessage].last
  end

  let(:chat_id) { 456 }
  let!(:user) { create(:user, chat_id:).tap { |user| create(:balance, user:, credits: 0) } }

  let(:open_store_markup) do
    { inline_keyboard: [[StarsPayment::OpenStoreButton.call(locale: I18n.default_locale)]] }
  end

  before do
    allow(Rails.env).to receive(:production?).and_return(false)
    stub_const("ENV", ENV.to_hash.merge("GENERATOR_WEBHOOK_BASE_URL" => "http://localhost:3000"))
  end

  shared_examples "an insufficient stones reply" do
    it { is_expected.to include(text: I18n.t("errors.insufficient_credits"), reply_to_message_id: 789) }

    context "when stars payments are enabled for the user" do
      before { Flipper.enable_actor(:flipper_stars_payments, user) }

      it { is_expected.to include(reply_markup: open_store_markup) }

      it "opens the buy stones Mini App" do
        expect(open_store_markup.dig(:inline_keyboard, 0, 0, :web_app, :url))
          .to eq("http://localhost:3000/mini_app/buy_stones")
      end
    end

    context "when stars payments are disabled for the user" do
      it { is_expected.not_to have_key(:reply_markup) }
    end
  end

  context "when tapping a Flux button" do
    let(:command_request) { create(:command_prompt_to_image_request, user:, chat_id:) }
    let(:prompt_message) do
      create(:prompt_message, prompt: "cute white kitten", command_request:, parent_request: command_request)
    end

    let(:update) do
      { callback_query: { id: "cbq-1", data: "flux_image", from: { id: chat_id },
                          message: { message_id: 789, chat: { id: chat_id }, entities: [] } } }
    end

    before { create(:bot_telegram_message, tg_message_id: 789, chat_id:, request: prompt_message) }

    it_behaves_like "an insufficient stones reply"
  end

  context "when sending an edit image prompt" do
    let(:command_request) { create(:command_edit_image_request, user:, chat_id:) }
    let(:session) { FakeSession.new.tap { |session| session[:command] = "edit_image" } }

    let(:update) do
      { message: { message_id: 789, date: Time.current.to_i, text: "make it pink",
                   chat: { id: chat_id }, from: { id: chat_id } } }
    end

    before do
      create(:user_image_url_message, command_request:, parent_request: command_request,
                                      image_url: "https://example.com/cat.png")
      allow_any_instance_of(described_class).to receive(:session).and_return(session)
      stub_openai_moderation(blocked: false)
    end

    it_behaves_like "an insufficient stones reply"
  end

  context "when a different error is raised" do
    let(:update) do
      { message: { message_id: 789, date: Time.current.to_i, text: "hello", chat: { id: chat_id },
                   from: { id: chat_id } } }
    end

    before { Flipper.enable(:flipper_stars_payments) }

    it "sends no keyboard" do
      expect(sent_message).not_to have_key(:reply_markup)
    end
  end
end
