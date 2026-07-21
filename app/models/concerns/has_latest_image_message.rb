module HasLatestImageMessage
  def latest_image_message
    candidates = [
      user_picture_messages.order(created_at: :desc).first,
      user_image_url_messages.order(created_at: :desc).first,
      user_file_messages.order(created_at: :desc).first
    ].compact

    candidates.max_by(&:created_at)
  end
end
