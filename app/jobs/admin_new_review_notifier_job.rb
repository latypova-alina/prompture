class AdminNewReviewNotifierJob < ApplicationJob
  def perform(review_id)
    Telegram.bot.send_message(
      chat_id: ENV.fetch("ADMIN_CHAT_ID"),
      text: Reviews::AdminNotificationPresenter.new(Review.find(review_id)).text
    )
  end
end
