module AdminCommands
  extend ActiveSupport::Concern

  included do
    before_action :authorize_admin, only: %i[
      random_script!
      motivation_prompt!
      motivation_script_en!
      motivation_script_pl!
      motivation_script_ru!
      random_character!
      script_templates!
      admin!
      generate_script!
    ]
  end

  def random_script!(*)
    ScriptGenerator::GenerateScriptJob.perform_async(chat["id"], nil)

    respond_with :message, text: "Started script generation."
  end

  def motivation_prompt!(*)
    ScriptGenerator::GenerateMotivationPromptJob.perform_async(chat["id"])

    respond_with :message, text: I18n.t("telegram_webhooks.commands.motivation_prompt")
  end

  def motivation_script_en!(*)
    enqueue_motivation_script!("en")
  end

  def motivation_script_pl!(*)
    enqueue_motivation_script!("pl")
  end

  def motivation_script_ru!(*)
    enqueue_motivation_script!("ru")
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

  def random_character!(*)
    ScriptGenerator::ProcessRandomCharacterJob.perform_async(chat["id"])

    respond_with :message, text: I18n.t("telegram_webhooks.commands.random_character")
  end

  def admin!(*)
    respond_with :message, text: I18n.t("telegram_webhooks.commands.admin")
  end

  private

  def enqueue_motivation_script!(language)
    ScriptGenerator::GenerateMotivationScriptJob.perform_async(chat["id"], language)

    respond_with :message, text: I18n.t("telegram_webhooks.commands.motivation_script")
  end
end
