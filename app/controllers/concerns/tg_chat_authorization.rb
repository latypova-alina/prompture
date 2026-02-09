module TgChatAuthorization
  extend ActiveSupport::Concern

  included { before_action :authorize_chat! }

  IMG_URL = "https://prompture.s3.eu-central-1.amazonaws.com/authorize/2.jpg".freeze

  private

  def authorize_chat!
    return if allowed_chat?

    respond_with :message, text: I18n.t("errors.unauthorized")
    respond_with(:photo, photo: IMG_URL)

    throw :abort
  end

  def allowed_chat?
    allowed_chat_ids.include?(chat["id"].to_s)
  end

  def allowed_chat_ids
    ENV.fetch("ALLOWED_TG_CHATS", "")
       .split(",")
       .map(&:strip)
  end
end
