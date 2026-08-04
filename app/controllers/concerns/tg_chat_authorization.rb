module TgChatAuthorization
  extend ActiveSupport::Concern
  include Memery

  UNAUTHORIZED_ACTIONS = %i[start! activate_token! message contact_support! help! prompt_policy!].freeze

  included { before_action :authorize_chat!, except: UNAUTHORIZED_ACTIONS }

  private

  def authorize_chat!
    return if allowed_chat?

    raise UnauthorizedError
  end

  def authorize_admin
    throw(:abort) unless admin_chat?
  end

  def allowed_chat?
    admin_chat? || user.present?
  end

  def admin_chat?
    user&.admin?
  end
end
