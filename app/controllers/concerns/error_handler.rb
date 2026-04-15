module ErrorHandler
  extend ActiveSupport::Concern
  include ErrorI18nResolver

  included do
    rescue_from CommandUnknownError, with: :handle_error
    rescue_from MessageTypeError, with: :handle_error
    rescue_from ImageUrlInvalid, with: :handle_error
    rescue_from ImageForgottenError, with: :handle_error
    rescue_from CommandRequestForgottenError, with: :handle_error
    rescue_from ParentNotFoundError, with: :handle_error
    rescue_from TokenNotFoundError, with: :handle_error
    rescue_from UnauthorizedError, with: :handle_error
    rescue_from TokenUsedError, with: :handle_error
    rescue_from TokenExpiredError, with: :handle_error
    rescue_from InsufficientCreditsError, with: :handle_error
    rescue_from ModerationError, with: :handle_error
  end

  private

  def handle_error(error)
    respond_with :message, text: I18n.t(error_i18n_key(error.class.name))
  end
end
