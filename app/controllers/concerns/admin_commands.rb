module AdminCommands
  extend ActiveSupport::Concern

  included do
    before_action :authorize_admin, only: %i[random_script! script_templates! admin! generate_script!]
  end

  def random_script!(*)
    ScriptGenerator::GenerateScriptJob.perform_async(chat["id"], nil)

    respond_with :message, text: "Started script generation."
  end

  def generate_script!(*)
    result = ScriptGenerator::GenerateScript.call(chat_id: chat["id"], message_body: update)

    raise result.error if result.failure?

    respond_with :message, text: "Started script generation."
  end

  def script_templates!(*)
    ScriptGenerator::SendScriptTemplatesJob.perform_async(chat["id"])

    respond_with :message, text: "Fetching script templates."
  end

  def admin!(*)
    respond_with :message, text: I18n.t("telegram_webhooks.commands.admin")
  end
end
