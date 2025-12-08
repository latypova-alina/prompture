module ErrorHandler
  extend ActiveSupport::Concern

  included do
    rescue_from CommandUnknownError, with: :handle_command_unknown
    rescue_from MessageTypeError, with: :handle_message_type_error
    rescue_from ImageForgottenError, with: :handle_image_forgotten
  end

  private

  def handle_command_unknown(_error)
    respond_with :message, text: I18n.t("errors.prompt_forgotten")
  end

  def handle_message_type_error(_error)
    respond_with :message, text: I18n.t("errors.wrong_message_type")
  end

  def handle_image_forgotten(_error)
    respond_with :message, text: I18n.t("errors.image_forgotten")
  end
end
