require "rails_helper"

# Outgoing calls go through the real Telegram::Bot::Client (HTTP stubbed), which the
# ClientInstrumentation hooks into.
describe ChatEvents::ClientInstrumentation do
  let(:client) { Telegram::Bot::Client.new("test-token") }

  # Use a real client (the test suite stubs all clients by default) - only HTTP is stubbed here.
  around { |example| Telegram::Bot::ClientStub.stub_all!(false) { example.run } }
  let(:api) { "https://api.telegram.org/bottest-token" }
  let(:chat_id) { 111 }
  let!(:user) { create(:user, chat_id:) }

  def stub_api(method, result:, status: 200)
    body = status < 300 ? { ok: true, result: } : { ok: false, description: result }
    stub_request(:post, "#{api}/#{method}").to_return(status:, body: body.to_json)
  end

  def outgoing
    ChatEvent.where(direction: "outgoing")
  end

  describe "send_message" do
    let(:keyboard) { { inline_keyboard: [[{ text: "🛒 Open Store", callback_data: "store" }]] } }

    before do
      stub_api("sendMessage", result: { message_id: 321 })
      client.send_message(chat_id:, text: "hello", parse_mode: "HTML", reply_markup: keyboard, reply_to_message_id: 7)
    end

    it do
      expect(outgoing.sole).to have_attributes(
        kind: "sendMessage", chat_id:, user_id: user.id, text: "hello", tg_message_id: 321, reply_to_message_id: 7
      )
    end

    it { expect(outgoing.sole.payload).to eq("parse_mode" => "HTML", "reply_markup" => keyboard.deep_stringify_keys) }
  end

  describe "delete_message" do
    before do
      stub_api("deleteMessage", result: true)
      client.delete_message(chat_id:, message_id: 55)
    end

    it { expect(outgoing.sole).to have_attributes(kind: "deleteMessage", tg_message_id: 55) }
  end

  describe "answer_callback_query" do
    before do
      create(:chat_event, direction: "incoming", kind: "callback_query", chat_id:,
                          payload: { "callback_query_id" => "cbq-9", "data" => "flux_image" })
      stub_api("answerCallbackQuery", result: true)
      client.answer_callback_query(callback_query_id: "cbq-9", text: "Image not ready yet", show_alert: true)
    end

    it "finds the chat through the recorded callback" do
      expect(outgoing.sole).to have_attributes(
        kind: "answerCallbackQuery", chat_id:, text: "Image not ready yet", payload: { "show_alert" => true }
      )
    end
  end

  describe "when Telegram returns an error" do
    before { stub_api("sendMessage", result: "Forbidden: bot was blocked by the user", status: 403) }

    it { expect { client.send_message(chat_id:, text: "hi") }.to raise_error(Telegram::Bot::Forbidden) }

    it "records the attempt with the error" do
      client.send_message(chat_id:, text: "hi")
    rescue Telegram::Bot::Forbidden
      expect(outgoing.sole.payload["error"])
        .to eq("class" => "Telegram::Bot::Forbidden", "message" => "Forbidden: bot was blocked by the user")
    end

    it "marks the user as blocked" do
      client.send_message(chat_id:, text: "hi")
    rescue Telegram::Bot::Forbidden
      expect(user.reload.blocked_at).to be_present
    end
  end

  describe "when Telegram rejects a send for another reason" do
    before { stub_api("sendMessage", result: "Forbidden: user is deactivated", status: 403) }

    it "doesn't mark the user as blocked" do
      client.send_message(chat_id:, text: "hi")
    rescue Telegram::Bot::Forbidden
      expect(user.reload.blocked_at).to be_nil
    end
  end

  describe "calls that aren't part of a user's conversation" do
    before do
      stub_api("setMyCommands", result: true)
      stub_api("sendMessage", result: { message_id: 1 })
      stub_const("ENV", ENV.to_hash.merge("ADMIN_CHAT_ID" => "-100"))

      client.set_my_commands(commands: [{ command: "help", description: "Help" }])
      client.send_message(chat_id: "-100", text: "📝 New review")
    end

    it { expect(outgoing).to be_empty }
  end

  describe "when recording fails" do
    before do
      stub_api("sendMessage", result: { message_id: 1 })
      allow(ChatEvent).to receive(:insert).and_raise(ActiveRecord::StatementInvalid)
      allow(Sentry).to receive(:capture_exception)
    end

    it { expect(client.send_message(chat_id:, text: "hi")).to eq("ok" => true, "result" => { "message_id" => 1 }) }
  end
end
