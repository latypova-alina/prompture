class AdminNewReviewNotifierJob < ApplicationJob
  include Memery

  def perform(review_id)
    @review_id = review_id

    Telegram.bot.send_message(chat_id: ENV.fetch("ADMIN_CHAT_ID"), text:)
  end

  private

  attr_reader :review_id

  delegate :text, to: :presenter

  memoize def presenter
    Reviews::AdminNotificationPresenter.new(review)
  end

  memoize def review
    Review.find(review_id)
  end
end
