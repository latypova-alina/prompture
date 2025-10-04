class TelegramWebhooksController < Telegram::Bot::UpdatesController
  include Telegram::Bot::UpdatesController::MessageContext

  def start!(*)
    respond_with :message, text: t("telegram_webhooks.start.content")
  end

  def message(message)
    session[:prompt] = message

    respond_with :message, MessagePresenter.new(
      message["text"],
      "prompt_message"
    ).reply_data
  end

  def callback_query(button_request)
    update_prompt(button_request)
    
    image_url = ImageProcessor.new(extended_description, button_request).image_url

    respond_with :message, ButtonMessagePresenter.new(
      image_url,
      "image_message",
      button_request
    ).reply_data
  rescue PromptForgottenError, ChatGpt::NoResponseError
    respond_with :message, text: I18n.t("errors.prompt_forgotten")
  end

  private

  def update_prompt(button_request)
    return unless button_request == "extend_description"

    session[:prompt] = ExtendedPrompt.new(session[:prompt]).extended_prompt
  end
end
