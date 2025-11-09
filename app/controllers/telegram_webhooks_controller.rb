class TelegramWebhooksController < Telegram::Bot::UpdatesController
  include Telegram::Bot::UpdatesController::MessageContext
  include SessionAccessor
  include ErrorHandler
  include MessageAccessor

  def start!(*)
    respond_with :message, text: t("telegram_webhooks.start.content")
  end

  def message(user_message)
    @user_message = user_message
    session[:image_prompt] = message_text
    session[:chat_id] = message_parser.chat_id

    respond_with :message, MessagePresenter.new(message_text, "initial_message").reply_data
  end

  def callback_query(button_request)
    session[:button_request] = button_request

    Generator::TaskCreatorSelectorJob.perform_async(image_prompt, image_url, button_request, chat_id)
  end

  private

  attr_reader :user_message

  delegate :message_text, to: :message_parser
  delegate :image_prompt, :image_url, :chat_id, to: :session_parser
end
