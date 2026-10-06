# Commands that start a generation flow: remember the command in the session, set up its command
# request, and ask the user for input. Image-input flows also require the current terms.
module GenerationCommands
  extend ActiveSupport::Concern

  def prompt_to_video!(*)
    start_generation_command("prompt_to_video")
  end

  def prompt_to_image!(*)
    start_generation_command("prompt_to_image")
  end

  def prompt_to_audio!(*)
    start_generation_command("prompt_to_audio")
  end

  def image_to_video!(*)
    start_generation_command("image_to_video") if terms_accepted?
  end

  def first_last_frame_to_video!(*)
    start_generation_command("first_last_frame_to_video") if terms_accepted?
  end

  def edit_image!(*)
    start_generation_command("edit_image") if terms_accepted?
  end

  private

  def start_generation_command(command)
    session[:command] = command

    MediaGenerator::CommandHandler::HandleCommand.call(command:, chat_id: chat["id"])

    respond_with :message, text: t("telegram_webhooks.commands.#{command}")
  end
end
