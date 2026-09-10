class AdminNewUserNotifierJob < ApplicationJob
  def perform
    Telegram.bot.send_message(
      chat_id: ENV.fetch("ADMIN_CHAT_ID"),
      text: I18n.t("admin_notifications.new_user", count: User.count)
    )
  end
end
