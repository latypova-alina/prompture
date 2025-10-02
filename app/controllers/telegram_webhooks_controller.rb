class TelegramWebhooksController < Telegram::Bot::UpdatesController
  include Telegram::Bot::UpdatesController::MessageContext

  def start!(*)
    respond_with :message, text: t("telegram_webhooks.start.content")
  end

  def message(message)
    extended_description = ExtendedDescription.new(message).description
    session[:extended_description] = extended_description

    respond_with :message, MessagePresenter.new(
      extended_description,
      { message_type: "prompt_message" }
    ).reply_data
  end

  def callback_query(data)
    extended_description = session[:extended_description] || raise(::PromptForgottenError)

    respond_with :message, MessagePresenter.new(
      extended_description,
      { message_type: "image_message", button_request: data }
    ).reply_data
  end
end
