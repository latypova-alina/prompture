# Hidden /review command (deliberately not in TelegramIntegration::CommandSync::COMMAND_NAMES).
module ReviewCommands
  extend ActiveSupport::Concern

  def review!(*)
    Reviews::CommandHandler::HandleCommand.call(chat_id: chat["id"], user:, locale: I18n.locale)
  end
end
