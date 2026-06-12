module AdminCommands
  extend ActiveSupport::Concern

  included do
    before_action :authorize_admin, only: %i[
      random_script!
      motivation_workflow_en!
      motivation_workflow_pl!
      motivation_workflow_ru!
      random_character!
      brainrot_character!
      cartoon_character!
      cartoon_yt!
      cartoon_shorts!
      script_templates!
      admin!
      generate_script!
    ]
  end

  def random_script!(*)
    ScriptGenerator::GenerateScriptJob.perform_async(chat["id"], nil)

    respond_with :message, text: "Started script generation."
  end

  def motivation_workflow_en!(*)
    enqueue_motivation_workflow!("en")
  end

  def motivation_workflow_pl!(*)
    enqueue_motivation_workflow!("pl")
  end

  def motivation_workflow_ru!(*)
    enqueue_motivation_workflow!("ru")
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

  def brainrot_character!(*)
    ScriptGenerator::ProcessBrainrotCharacterJob.perform_async(chat["id"])

    respond_with :message, text: I18n.t("telegram_webhooks.commands.brainrot_character")
  end

  def cartoon_character!(*)
    ScriptGenerator::ProcessCartoonCharacterJob.perform_async(chat["id"])

    respond_with :message, text: I18n.t("telegram_webhooks.commands.cartoon_character")
  end

  def cartoon_yt!(*)
    ScriptGenerator::ProcessCartoonScriptJob.perform_async(chat["id"])

    respond_with :message, text: I18n.t("telegram_webhooks.commands.cartoon_yt")
  end

  def cartoon_shorts!(*)
    ScriptGenerator::ProcessCartoonShortsScriptJob.perform_async(chat["id"])

    respond_with :message, text: I18n.t("telegram_webhooks.commands.cartoon_shorts")
  end

  def admin!(*)
    respond_with :message, text: I18n.t("telegram_webhooks.commands.admin")
  end

  private

  def enqueue_motivation_workflow!(language)
    ScriptGenerator::ForMotivation::GenerateMotivationWorkflowJob.perform_async(chat["id"], language)

    respond_with :message, text: I18n.t("telegram_webhooks.commands.motivation_workflow")
  end
end
