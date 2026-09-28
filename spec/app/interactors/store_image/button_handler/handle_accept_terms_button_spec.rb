require "rails_helper"

describe StoreImage::ButtonHandler::HandleAcceptTermsButton do
  subject(:call) do
    described_class.call(
      button_request:,
      chat_id:,
      tg_message_id:,
      callback_query_id:
    )
  end

  let(:user) { create(:user) }
  let(:command_request) { create(:command_prompt_to_image_request, user:) }
  let(:record) { create(:user_image_url_message, command_request:, parent_request: command_request) }
  let(:button_request) { "accept_terms:#{record.class.name}:#{record.id}" }
  let(:chat_id) { user.chat_id }
  let(:tg_message_id) { 789 }
  let(:callback_query_id) { "12345" }
  let(:telegram_bot) { double }

  before do
    allow(Telegram).to receive(:bot).and_return(telegram_bot)
    allow(telegram_bot).to receive(:answer_callback_query)
    allow(telegram_bot).to receive(:edit_message_text)
    allow(StoreImage::SuccessNotifierJob).to receive(:perform_async)
  end

  it "creates a policy acceptance for the user" do
    expect { call }.to change { user.policy_acceptances.count }.by(1)
  end

  it "acknowledges the callback query" do
    call

    expect(telegram_bot).to have_received(:answer_callback_query).with(callback_query_id:)
  end

  it "edits the gate message" do
    call

    expect(telegram_bot).to have_received(:edit_message_text).with(
      chat_id:,
      message_id: tg_message_id,
      text: I18n.t("telegram_webhooks.message.terms_gate.accepted", locale: user.locale),
      reply_markup: { inline_keyboard: [] }
    )
  end

  it "re-enqueues the success notifier job to resume processing the same record" do
    call

    expect(StoreImage::SuccessNotifierJob)
      .to have_received(:perform_async).with(record.class.name, record.id.to_s)
  end

  it "succeeds" do
    expect(call).to be_success
  end

  describe ".organized" do
    it "organizes interactors in correct order" do
      expect(described_class.organized).to eq(
        [
          StoreImage::ButtonHandler::ParseButtonRequest,
          StoreImage::ButtonHandler::AcknowledgeCallbackQuery,
          MiniApp::BuyStones::AcceptTerms,
          StoreImage::ButtonHandler::EditGateMessage,
          StoreImage::ButtonHandler::ResumeNotification
        ]
      )
    end
  end
end
