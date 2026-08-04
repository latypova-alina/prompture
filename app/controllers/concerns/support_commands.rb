module SupportCommands
  extend ActiveSupport::Concern

  def help!(*)
    respond_with :message, text: I18n.t("telegram_webhooks.commands.help")
  end

  def prompt_policy!(*)
    respond_with :message, text: I18n.t("telegram_webhooks.commands.prompt_policy")
  end

  def contact_support!(*)
    respond_with :message, text: t("telegram_webhooks.commands.contact_support", support_email:)
  end

  private

  def support_email
    Rails.application.config.x.support_email
  end
end
