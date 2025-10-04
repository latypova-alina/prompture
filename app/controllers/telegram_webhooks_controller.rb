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
      "prompt_message"
    ).reply_data
  end

  def callback_query(button_request)
    extended_description = session[:extended_description] || raise(::PromptForgottenError)

    image_url = ImageProcessor.new(extended_description, button_request).image_url

    respond_with :message, ButtonMessagePresenter.new(
      image_url,
      "image_message",
      button_request
    ).reply_data
  rescue PromptForgottenError
    respond_with :message, text: I18n.t("errors.prompt_forgotten")
  end
end
