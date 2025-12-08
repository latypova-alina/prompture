class TelegramWebhooksController < Telegram::Bot::UpdatesController
  include Telegram::Bot::UpdatesController::MessageContext
  include SessionAccessor
  include ErrorHandler

  def start!(*)
    respond_with :message, text: t("telegram_webhooks.start.content")
  end

  def message(user_message)
    handled_message = MessageHandler::HandleMessage.call(
      user_message:,
      command: session[:command],
      button_request: session[:button_request]
    )

    raise handled_message.context.error if handled_message.failure?
  end

  def prompt_to_video!(*)
    session[:command] = "prompt_to_video"

    HandleCommand.call(command: session[:command], chat_id: chat["id"])

    respond_with :message, text: t("telegram_webhooks.start.prompt_to_video")
  end

  def prompt_to_image!(*)
    session[:command] = "prompt_to_image"

    HandleCommand.call(command: session[:command], chat_id: chat["id"])

    respond_with :message, text: t("telegram_webhooks.start.prompt_to_image")
  end

  def image_to_video!(*)
    session[:command] = "image_to_video!"

    HandleCommand.call(command: session[:command], chat_id: chat["id"])

    respond_with :message, text: t("telegram_webhooks.start.image_to_video!")
  end

  def image_from_reference!(*)
    session[:command] = "image_from_reference!"

    HandleCommand.call(command: session[:command], chat_id: chat["id"])

    respond_with :message, text: t("telegram_webhooks.start.image_from_reference")
  end

  def callback_query(button_request)
    session[:button_request] = button_request

    ButtonHandler::HandleButton.call(
      button_request:,
      command: session["command"],
      chat_id: chat["id"],
      image_url: update["callback_query"]["message"]["entities"][0]["url"]
    )
  end

  private

  delegate :image_prompt, to: :session_parser
end
