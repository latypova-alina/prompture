module AdminCommands
  extend ActiveSupport::Concern

  included do
    before_action :authorize_admin, only: %i[
      generate_random_cats_script!
      motivation_workflow_en!
      motivation_workflow_pl!
      motivation_workflow_ru!
      food_character!
      brainrot_character!
      cartoon_character!
      bloomy_multiscene_cartoon_yt!
      bloomy_cartoon_short!
      bloomy_complex_short!
      cats_script_templates!
      admin!
      generate_cats_script!
    ]
  end

  def generate_random_cats_script!(*)
    ScriptGenerator::ForCats::GenerateScriptJob.perform_async(chat["id"], nil)

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

  def generate_cats_script!(*)
    result = ScriptGenerator::ForCats::Generate.call(chat_id: chat["id"], message_body: update)

    raise result.error if result.failure?

    respond_with :message, text: "Started script generation."
  end

  def cats_script_templates!(*)
    ScriptGenerator::ForCats::SendScriptTemplatesJob.perform_async(chat["id"])

    respond_with :message, text: "Fetching script templates."
  end

  def food_character!(*)
    ScriptGenerator::Process::RandomCharacterJob.perform_async(chat["id"])

    respond_with :message, text: I18n.t("telegram_webhooks.commands.food_character")
  end

  def brainrot_character!(*)
    ScriptGenerator::Process::BrainrotCharacterJob.perform_async(chat["id"])

    respond_with :message, text: I18n.t("telegram_webhooks.commands.brainrot_character")
  end

  def cartoon_character!(*)
    ScriptGenerator::Process::CartoonCharacterJob.perform_async(chat["id"])

    respond_with :message, text: I18n.t("telegram_webhooks.commands.cartoon_character")
  end

  def bloomy_multiscene_cartoon_yt!(*)
    ScriptGenerator::Process::ForBloomy::MultiSceneScriptJob.perform_async(chat["id"])

    respond_with :message, text: I18n.t("telegram_webhooks.commands.bloomy_multiscene_cartoon_yt")
  end

  def bloomy_cartoon_short!(*)
    ScriptGenerator::Process::ForBloomy::SingleScriptJob.perform_async(
      chat["id"],
      ContentCategory::CARTOON_BLOOMY_SHORTS_SCRIPT
    )

    respond_with :message, text: I18n.t("telegram_webhooks.commands.bloomy_cartoon_short")
  end

  def bloomy_complex_short!(*)
    ScriptGenerator::Process::ForBloomy::ShortComplexScriptJob.perform_async(chat["id"])

    respond_with :message, text: I18n.t("telegram_webhooks.commands.bloomy_complex_short")
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
