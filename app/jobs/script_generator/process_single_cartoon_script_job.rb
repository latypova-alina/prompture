module ScriptGenerator
  class ProcessSingleCartoonScriptJob < ApplicationJob
    include JobErrorHandler

    def perform(chat_id, category = ContentCategory::CARTOON_SCRIPT)
      ScriptGenerator::ForCartoon::ProcessSingleCartoonScript.call(chat_id:, category:)
    rescue StandardError => e
      notify_script_generator_error(chat_id:, error: e)
    end
  end
end
