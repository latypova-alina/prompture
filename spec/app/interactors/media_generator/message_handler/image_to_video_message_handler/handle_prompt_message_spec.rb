require "rails_helper"

describe MediaGenerator::MessageHandler::ImageToVideoMessageHandler::HandlePromptMessage do
  subject(:result) do
    described_class.call(
      command: "image_to_video",
      user_message: { "text" => prompt_text, "chat" => { "id" => chat_id } }
    )
  end

  let(:prompt_text) { "ocean waves at sunset" }
  let(:command_request) { create(:command_image_to_video_request, awaiting_video_prompt: true) }
  let(:chat_id) { command_request.chat_id }

  before do
    picture_message = create(
      :user_picture_message,
      command_request:,
      parent_request: command_request
    )
    create(:stored_image, source_message: picture_message, image_url: "https://example.com/image.png")
    allow(Moderation::OpenaiModeration).to receive(:flagged?).and_return(false)
    allow(TelegramIntegration::SendMessageWithButtons).to receive(:call)
  end

  it "creates prompt message, clears awaiting flag, and sends video processor buttons" do
    expect { result }.to change(PromptMessage, :count).by(1)
                                                      .and change {
                                                             command_request.reload.awaiting_video_prompt
                                                           }.from(true).to(false)

    prompt_message = PromptMessage.last
    expect(prompt_message.prompt).to eq(prompt_text)
    expect(prompt_message.parent_request).to eq(command_request.latest_image_message)

    expect(TelegramIntegration::SendMessageWithButtons).to have_received(:call).with(
      reply_data: hash_including(
        text: I18n.t("telegram_webhooks.message.image_message_reply", locale: command_request.user.locale)
      ),
      request: prompt_message
    )
  end
end
