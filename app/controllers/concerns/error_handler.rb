module ErrorHandler
  extend ActiveSupport::Concern

  included do
    rescue_from PromptForgottenError, with: :handle_prompt_forgotten
    rescue_from ChatGpt::ResponseError, with: :handle_external_service_error
    rescue_from Freepik::ResponseError, with: :handle_external_service_error
    rescue_from Freepik::ImageGenerationFailed, with: :handle_image_generating_error
    rescue_from Freepik::ImageGenerationTimeout, with: :handle_image_generating_timeout_error
    rescue_from Freepik::VideoGenerationFailed, with: :handle_video_generating_error
    rescue_from Freepik::VideoGenerationTimeout, with: :handle_video_generating_timeout_error
  end

  private

  def handle_prompt_forgotten(_error)
    respond_with :message, text: I18n.t("errors.prompt_forgotten")
  end

  def handle_external_service_error(_error)
    respond_with :message, text: I18n.t("errors.external_service_error")
  end

  def handle_image_generating_error(_error)
    respond_with :message, text: I18n.t("errors.image_generating_error")
  end

  def handle_image_generating_timeout_error(_error)
    respond_with :message, text: I18n.t("errors.image_generating_timeout_error")
  end

  def handle_video_generating_error(_error)
    respond_with :message, text: I18n.t("errors.video_generating_error")
  end

  def handle_video_generating_timeout_error(_error)
    respond_with :message, text: I18n.t("errors.video_generating_timeout_error")
  end
end
