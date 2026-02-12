module TgChatAuthorization
  extend ActiveSupport::Concern
  include Memery

  included { before_action :authorize_chat!, except: [:start!] }

  IMG_URL = "https://prompture.s3.eu-central-1.amazonaws.com/authorize/2.jpg".freeze

  private

  def authorize_chat!
    return if allowed_chat?

    respond_with(:photo, photo: IMG_URL)

    raise UnauthorizedError
  end

  def allowed_chat?
    allowed_chat_ids.include?(chat["id"].to_s) || user.present?
  end

  def allowed_chat_ids
    ENV.fetch("ALLOWED_TG_CHATS", "")
       .split(",")
       .map(&:strip)
  end

  memoize def user
    User.find_by(chat_id: chat["id"])
  end
end
