class TelegramWebhooksController < Telegram::Bot::UpdatesController
  include Telegram::Bot::UpdatesController::MessageContext
  include AdminCommands
  include TelegramLocale
  include SessionAccessor
  include ErrorHandler
  include TgChatAuthorization
  include StarsPayments
  include SupportCommands
  include ReviewCommands
  include GenerationCommands

  def start!(token_code = nil)
    handled_token = TokenHandler::HandleToken.call(
      token_code:,
      chat_id: chat["id"],
      name: chat["first_name"],
      locale: normalized_locale
    )

    NewUserBonusHandler::HandleNewUser.call(user: handled_token.user, chat_id: chat["id"], token_code:)

    respond_with :message, text: start_message_for(handled_token)
  end

  def activate_token!(*)
    session[:command] = "activate_token"

    respond_with :message, text: I18n.t("telegram_webhooks.commands.activate_token.ask")
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

  def terms_accepted?
    return true if user.nil?

    TermsGate::Check.call(user:, chat_id: chat["id"], locale: user.locale)
  end

  def start_message_for(handled_token)
    return t("telegram_webhooks.commands.start.no_token") unless handled_token.success?

    t("telegram_webhooks.commands.start.with_valid_token", credits: handled_token.token.credits)
  end
end
