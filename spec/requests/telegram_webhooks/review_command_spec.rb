require "rails_helper"
require "telegram/bot/rspec/integration/rails"

describe TelegramWebhooksController, telegram_bot: :rails do
  subject(:sent_message) do
    dispatch_command(:review)
    bot.requests[:sendMessage].last
  end

  let(:chat_id) { 456 }
  let!(:user) { create(:user, :with_balance, chat_id:) }

  before do
    allow(Rails.env).to receive(:production?).and_return(false)
    stub_const("ENV", ENV.to_hash.merge("GENERATOR_WEBHOOK_BASE_URL" => "http://localhost:3000"))
  end

  it { is_expected.to include(text: I18n.t("telegram_webhooks.commands.review.ask")) }

  it "has a button that opens the review mini app" do
    expect(sent_message[:reply_markup]).to eq(
      inline_keyboard: [[{ text: I18n.t("telegram_webhooks.commands.review.button"),
                           web_app: { url: "http://localhost:3000/mini_app/review" } }]]
    )
  end

  context "when the review bonus is on" do
    before { Flipper.enable_actor(:flipper_review_bonus, user) }

    it do
      is_expected.to include(text: I18n.t("telegram_webhooks.commands.review.ask_with_reward", count: 50))
    end
  end

  context "when the user already left a review" do
    before { create(:review, user:) }

    it { is_expected.to include(text: I18n.t("telegram_webhooks.commands.review.already_reviewed")) }
    it { is_expected.not_to have_key(:reply_markup) }
  end

  it "stays out of the bot's command menu" do
    expect(TelegramIntegration::CommandSync::COMMAND_NAMES).not_to include("review")
  end
end
