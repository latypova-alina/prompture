class TelegramWebhooksController < Telegram::Bot::UpdatesController
  include Telegram::Bot::UpdatesController::MessageContext
  include ErrorHandler

  def start!(*)
    respond_with :message, text: t("telegram_webhooks.start.content")
  end

  def message(message)
    session[:image_prompt] = message["text"]

    respond_with :message, MessagePresenter.new(message["text"], "initial_message").reply_data
  end

  def callback_query(button_request)
    strategy = Strategies::Selector.new(button_request, safe_session).strategy

    respond_with :message, strategy.reply_data
  end

  private

  def safe_session
    session.to_h unless session.loaded?
    session
  end
end
