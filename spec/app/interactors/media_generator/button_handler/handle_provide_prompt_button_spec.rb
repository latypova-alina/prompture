require "rails_helper"

describe MediaGenerator::ButtonHandler::HandleProvidePromptButton do
  subject(:result) do
    described_class.call(
      button_request: ButtonActions::PROVIDE_PROMPT,
      chat_id:,
      tg_message_id:,
      callback_query_id: "cb-1"
    )
  end

  let(:chat_id) { command_request.chat_id }
  let(:command_request) { create(:command_image_to_video_request) }
  let(:picture_message) do
    create(:user_picture_message, command_request:, parent_request: command_request)
  end
  let(:tg_message_id) { 99 }

  before do
    create(:bot_telegram_message, request: picture_message, chat_id:, tg_message_id:)
    allow(Telegram.bot).to receive(:send_message)
    allow(Telegram.bot).to receive(:answer_callback_query)
  end

  it "marks command as awaiting video prompt and sends reply" do
    expect { result }.to change { command_request.reload.awaiting_video_prompt }.from(false).to(true)

    expect(Telegram.bot).to have_received(:send_message).with(
      chat_id:,
      text: I18n.t("telegram_webhooks.message.image_to_video_prompt_reply", locale: command_request.user.locale)
    )
    expect(Telegram.bot).to have_received(:answer_callback_query).with(callback_query_id: "cb-1")
  end
end
