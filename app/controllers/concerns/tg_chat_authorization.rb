module TgChatAuthorization
  extend ActiveSupport::Concern
  include Memery

  included { before_action :authorize_chat!, except: %i[start! activate_token! message] }

  private

  def authorize_chat!
    return if allowed_chat?

    raise UnauthorizedError
  end

  def authorize_admin
    raise AdminOnlyCommandError unless admin_chat?
  end

  def allowed_chat?
    admin_chat? || user.present?
  end

  def admin_chat?
    user&.admin?
  end
end
