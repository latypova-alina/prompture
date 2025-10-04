class TelegramWebhooksController < Telegram::Bot::UpdatesController
  include Telegram::Bot::UpdatesController::MessageContext

  def start!(*)
    respond_with :message, text: t("telegram_webhooks.start.content")
  end

  def message(message)
    session[:prompt] = message["text"]

    respond_with :message, MessagePresenter.new(message["text"], "initial_message").reply_data
  end

  def callback_query(button_request)
    strategy = Strategies::Selector.new(button_request, safe_session).strategy
        
    respond_with :message, strategy.reply_data
  rescue PromptForgottenError, ChatGpt::NoResponseError
    respond_with :message, text: I18n.t("errors.prompt_forgotten")
  end

  private

  def safe_session
    session.to_h unless session.loaded?
    session
  end
end
