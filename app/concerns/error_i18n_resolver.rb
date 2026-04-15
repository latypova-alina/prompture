module ErrorI18nResolver
  ERROR_I18N_KEYS = {
    "CommandUnknownError" => "errors.command_unknown",
    "MessageTypeError" => "errors.wrong_message_type",
    "ImageUrlInvalid" => "errors.image_url_invalid",
    "ImageForgottenError" => "errors.image_forgotten",
    "CommandRequestForgottenError" => "errors.command_request_forgotten",
    "ParentNotFoundError" => "errors.parent_not_found",
    "TokenNotFoundError" => "errors.token_not_found",
    "UnauthorizedError" => "errors.unauthorized",
    "TokenUsedError" => "errors.token_used",
    "TokenExpiredError" => "errors.token_expired",
    "InsufficientCreditsError" => "errors.insufficient_credits",
    "ModerationError" => "errors.moderation",
    "ImageResolutionError" => "errors.image_resolution"
  }.freeze

  DEFAULT_ERROR_I18N_KEY = "errors.unknown".freeze

  private

  def error_i18n_key(error_class_name)
    ERROR_I18N_KEYS.fetch(error_class_name.to_s, DEFAULT_ERROR_I18N_KEY)
  end
end
