class TelegramWebhooksController < Telegram::Bot::UpdatesController
  include Telegram::Bot::UpdatesController::MessageContext
  include AdminCommands
  include TelegramLocale
  include SessionAccessor
  include ErrorHandler
  include TgChatAuthorization
  include StarsPayments

  def start!(token_code = nil)
    handled_token = TokenHandler::HandleToken.call(
      token_code:,
      chat_id: chat["id"],
      name: chat["first_name"],
      locale: normalized_locale
    )

    respond_with :message, text: start_message_for(handled_token)
  end

  def activate_token!(*)
    session[:command] = "activate_token"

    respond_with :message, text: I18n.t("telegram_webhooks.commands.activate_token.ask")
  end

  def help!
    respond_with :message, text: I18n.t("telegram_webhooks.commands.help")
  end

  def prompt_policy!(*)
    respond_with :message, text: I18n.t("telegram_webhooks.commands.prompt_policy")
  end

  def contact_support!(*)
    respond_with :message, text: t("telegram_webhooks.commands.contact_support", support_email:)
  end

  def message(user_message)
    TelegramIntegration::MessageDispatcher.call(
      command: session[:command],
      chat_id: chat["id"],
      user_message:,
      name: chat["first_name"],
      locale: normalized_locale
    )
  end

  def prompt_to_video!(*)
    session[:command] = "prompt_to_video"

    MediaGenerator::CommandHandler::HandleCommand.call(command: session[:command], chat_id: chat["id"])

    respond_with :message, text: t("telegram_webhooks.commands.prompt_to_video")
  end

  def set_locale!(*)
    SetLocale::CommandHandler::HandleCommand.call(
      chat_id: chat["id"],
      locale: normalized_locale
    )
  end

  def balance!(*)
    credits = user.balance.credits
    respond_with :message, text: t("telegram_webhooks.commands.balance", balance: credits, count: credits)
  end

  def prompt_to_image!(*)
    session[:command] = "prompt_to_image"

    MediaGenerator::CommandHandler::HandleCommand.call(command: session[:command], chat_id: chat["id"])

    respond_with :message, text: t("telegram_webhooks.commands.prompt_to_image")
  end

  def prompt_to_audio!(*)
    session[:command] = "prompt_to_audio"

    MediaGenerator::CommandHandler::HandleCommand.call(command: session[:command], chat_id: chat["id"])

    respond_with :message, text: t("telegram_webhooks.commands.prompt_to_audio")
  end

  def image_to_video!(*)
    session[:command] = "image_to_video"

    MediaGenerator::CommandHandler::HandleCommand.call(command: session[:command], chat_id: chat["id"])

    respond_with :message, text: t("telegram_webhooks.commands.image_to_video")
  end

  def first_last_frame_to_video!(*)
    session[:command] = "first_last_frame_to_video"

    MediaGenerator::CommandHandler::HandleCommand.call(command: session[:command], chat_id: chat["id"])

    respond_with :message, text: t("telegram_webhooks.commands.first_last_frame_to_video")
  end

  def edit_image!(*)
    session[:command] = "edit_image"

    MediaGenerator::CommandHandler::HandleCommand.call(command: session[:command], chat_id: chat["id"])

    respond_with :message, text: t("telegram_webhooks.commands.edit_image")
  end

  def callback_query(button_request)
    TelegramIntegration::CallbackQuery::CallbackQueryDispatcher.call(
      button_request:,
      chat_id: chat["id"],
      tg_message_id:,
      callback_query_id:
    )
  end

  private

  def tg_message_id
    update["callback_query"].dig("message", "message_id")
  end

  def callback_query_id
    update["callback_query"]["id"]
  end

  memoize def user
    User.eager_load(:balance).find_by(chat_id: chat&.dig("id") || from["id"])
  end

  def start_message_for(handled_token)
    return t("telegram_webhooks.commands.start.no_token") unless handled_token.success?

    t("telegram_webhooks.commands.start.with_valid_token", credits: handled_token.token.credits)
  end
end
