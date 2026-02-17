class TelegramWebhooksController < Telegram::Bot::UpdatesController
  include Telegram::Bot::UpdatesController::MessageContext
  include SessionAccessor
  include ErrorHandler
  include TgChatAuthorization

  def start!(token_code = nil)
    handled_token = TokenHandler::HandleToken.call(
      token_code:,
      chat_id: chat["id"],
      name: chat["first_name"]
    )

    raise handled_token.error if handled_token.failure?
  end

  def message(user_message)
    handled_message = MessageHandler::HandleMessage.call(
      user_message:,
      command: session[:command]
    )

    raise handled_message.error if handled_message.failure?
  end

  def prompt_to_video!(*)
    session[:command] = "prompt_to_video"

    HandleCommand.call(command: session[:command], chat_id: chat["id"])

    respond_with :message, text: t("telegram_webhooks.commands.prompt_to_video")
  end

  def balance!(*)
    respond_with :message, text: t("telegram_webhooks.commands.balance", balance: user.balance.credits)
  end

  def prompt_to_image!(*)
    session[:command] = "prompt_to_image"

    HandleCommand.call(command: session[:command], chat_id: chat["id"])

    respond_with :message, text: t("telegram_webhooks.commands.prompt_to_image")
  end

  def image_to_video!(*)
    session[:command] = "image_to_video!"

    HandleCommand.call(command: session[:command], chat_id: chat["id"])

    respond_with :message, text: t("telegram_webhooks.commands.image_to_video!")
  end

  def image_from_reference!(*)
    session[:command] = "image_from_reference"

    HandleCommand.call(command: session[:command], chat_id: chat["id"])

    respond_with :message, text: t("telegram_webhooks.commands.image_from_reference")
  end

  def callback_query(button_request)
    handled_button = ButtonHandler::HandleButton.call(
      button_request:,
      image_url: image_url_from_message,
      chat_id: chat["id"],
      tg_message_id:,
      callback_query_id:
    )

    raise handled_button.error if handled_button.failure?
  end

  private

  def image_url_from_message
    update["callback_query"].dig("message", "entities", 0, "url")
  end

  def tg_message_id
    update["callback_query"].dig("message", "message_id")
  end

  def callback_query_id
    update["callback_query"]["id"]
  end

  memoize def user
    User.eager_load(:balance).find_by(chat_id: chat["id"])
  end
end
