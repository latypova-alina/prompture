module ScriptGenerator
  class ProcessCartoonScriptJob < ApplicationJob
    include JobErrorHandler

    def perform(chat_id)
      ScriptGenerator::ForCartoon::ProcessCartoonScript.call(chat_id:)
    rescue StandardError => e
      notify_script_generator_error(chat_id:, error: e)
    end
  end
end
