class TelegramWebhooksController < Telegram::Bot::UpdatesController
  include Telegram::Bot::UpdatesController::MessageContext

  def start!(*)
    respond_with :message, text: t("telegram_webhooks.start.content")
  end

  def message(message)
    extended_description = ExtendedDescription.new(message).description

    respond_with :message, text: extended_description
  end
end
