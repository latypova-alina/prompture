module TgChatAuthorization
  extend ActiveSupport::Concern
  include Memery

  included { before_action :authorize_chat!, except: %i[start! activate_token! message] }

  private

  def authorize_chat!
    return if allowed_chat?

    raise UnauthorizedError
  end

  def allowed_chat?
    admin_chat_ids.include?(chat["id"].to_s) || user.present?
  end

  def admin_chat_ids
    ENV.fetch("ADMIN_TG_CHATS", "")
       .split(",")
       .map(&:strip)
  end
end
