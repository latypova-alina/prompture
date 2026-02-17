module ErrorHandler
  extend ActiveSupport::Concern

  included do
    rescue_from CommandUnknownError, with: :handle_command_unknown
    rescue_from MessageTypeError, with: :handle_message_type_error
    rescue_from ImageForgottenError, with: :handle_image_forgotten
    rescue_from CommandRequestForgottenError, with: :handle_command_request_forgotten
    rescue_from ParentNotFoundError, with: :handle_parent_not_found
    rescue_from TokenNotFoundError, with: :handle_token_not_found
    rescue_from UnauthorizedError, with: :handle_unauthorized
    rescue_from TokenUsedError, with: :handle_token_used
    rescue_from TokenExpiredError, with: :handle_token_expired
    rescue_from TokenActivatedError, with: :handle_token_activated
    rescue_from InsufficientCreditsError, with: :handle_insufficient_credits
  end

  private

  def handle_command_unknown(_error)
    respond_with :message, text: I18n.t("errors.command_unknown")
  end

  def handle_message_type_error(_error)
    respond_with :message, text: I18n.t("errors.wrong_message_type")
  end

  def handle_image_forgotten(_error)
    respond_with :message, text: I18n.t("errors.image_forgotten")
  end

  def handle_command_request_forgotten(_error)
    respond_with :message, text: I18n.t("errors.command_request_forgotten")
  end

  def handle_parent_not_found(_error)
    respond_with :message, text: I18n.t("errors.parent_not_found")
  end

  def handle_token_not_found(_error)
    respond_with :message, text: I18n.t("errors.token_not_found")
  end

  def handle_unauthorized(_error)
    respond_with :message, text: I18n.t("errors.unauthorized")
  end

  def handle_token_used(_error)
    respond_with :message, text: I18n.t("errors.token_used")
  end

  def handle_token_expired(_error)
    respond_with :message, text: I18n.t("errors.token_expired")
  end

  def handle_token_activated(_error)
    respond_with :message, text: I18n.t("errors.token_activated")
  end

  def handle_insufficient_credits(_error)
    respond_with :message, text: I18n.t("errors.insufficient_credits")
  end
end
