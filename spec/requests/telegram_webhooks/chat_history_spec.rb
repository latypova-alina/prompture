require "rails_helper"
require "telegram/bot/rspec/integration/rails"

# Every incoming update is recorded before handling (allowlisted fields only), and replies sent
# through respond_with are recorded as outgoing events.
describe TelegramWebhooksController, telegram_bot: :rails do
  let(:chat_id) { 111 }
  let!(:user) { create(:user, :with_balance, chat_id:) }
  let(:from) { { id: chat_id, first_name: "Alina" } }
  let(:chat) { { id: chat_id, type: "private" } }

  def incoming
    ChatEvent.where(direction: "incoming")
  end

  describe "a text message" do
    let(:update) do
      { update_id: 1001, message: { message_id: 11, date: 1_700_000_000, from:, chat:, text: "/help" } }
    end

    before { dispatch(update) }

    it do
      expect(incoming.sole).to have_attributes(
        kind: "message", chat_id:, user_id: user.id, update_id: 1001, tg_message_id: 11, text: "/help",
        occurred_at: Time.zone.at(1_700_000_000), payload: { "message_type" => "text" }
      )
    end

    it "records the reply sent with respond_with" do
      expect(ChatEvent.where(direction: "outgoing").sole)
        .to have_attributes(kind: "sendMessage", chat_id:, text: I18n.t("telegram_webhooks.commands.help"))
    end

    context "when Telegram delivers the same update again" do
      before { dispatch(update) }

      it { expect(incoming.count).to eq(1) }
    end
  end

  describe "a photo" do
    before do
      dispatch(update_id: 1002, message: {
                 message_id: 12, date: 1_700_000_000, from:, chat:, caption: "make it pink",
                 photo: [{ file_id: "small", file_unique_id: "u1", file_size: 100, width: 90, height: 90 },
                         { file_id: "large", file_unique_id: "u2", file_size: 900, width: 1280, height: 1280 }]
               })
    end

    it { expect(incoming.sole.text).to eq("make it pink") }

    it do
      expect(incoming.sole.payload).to eq(
        "message_type" => "photo",
        "media" => [{ "file_id" => "small", "file_size" => 100, "width" => 90, "height" => 90 },
                    { "file_id" => "large", "file_size" => 900, "width" => 1280, "height" => 1280 }]
      )
    end
  end

  describe "a shared contact" do
    before do
      dispatch(update_id: 1003, message: { message_id: 13, date: 1_700_000_000, from:, chat:,
                                           contact: { phone_number: "+15550001111", first_name: "Bob" } })
    end

    it "keeps only the message type, not the phone number" do
      expect(incoming.sole.payload).to eq("message_type" => "contact")
    end
  end

  describe "a callback query" do
    before do
      dispatch(update_id: 1004, callback_query: { id: "cbq-1", data: "flux_image", from:,
                                                  message: { message_id: 789, chat:, entities: [] } })
    end

    it do
      expect(incoming.sole).to have_attributes(
        kind: "callback_query", chat_id:, tg_message_id: 789,
        payload: { "callback_query_id" => "cbq-1", "data" => "flux_image" }
      )
    end
  end

  describe "a successful payment" do
    before do
      dispatch(update_id: 1005, message: {
                 message_id: 14, date: 1_700_000_000, from:, chat:,
                 successful_payment: { currency: "XTR", total_amount: 450, invoice_payload: "medium",
                                       telegram_payment_charge_id: "charge_1", provider_payment_charge_id: "" }
               })
    end

    it do
      expect(incoming.sole).to have_attributes(
        kind: "successful_payment",
        payload: { "currency" => "XTR", "total_amount" => 450, "invoice_payload" => "medium",
                   "telegram_payment_charge_id" => "charge_1" }
      )
    end
  end

  describe "a chat that has no user yet (never started, never accepted the terms)" do
    before do
      dispatch(update_id: 1006, message: { message_id: 15, date: 1_700_000_000, text: "hi",
                                           from: { id: 999 }, chat: { id: 999 } })
    end

    it { expect(incoming.sole).to have_attributes(chat_id: 999, user_id: nil, text: "hi") }
  end

  describe "when recording fails" do
    before do
      allow(ChatEvent).to receive(:insert).and_raise(ActiveRecord::StatementInvalid)
      allow(Sentry).to receive(:capture_exception)
    end

    it "still handles the update" do
      dispatch(update_id: 1007, message: { message_id: 16, date: 1_700_000_000, from:, chat:, text: "/help" })

      expect(bot.requests[:sendMessage].last).to include(text: I18n.t("telegram_webhooks.commands.help"))
    end
  end
end
