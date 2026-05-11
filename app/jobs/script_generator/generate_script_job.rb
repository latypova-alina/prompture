module ScriptGenerator
  class GenerateScriptJob < ApplicationJob
    include JobErrorHandler

    def perform(chat_id, template_name = nil)
      ScriptGenerator::ProcessGeneratedScripts.call(chat_id:, template_name:)
    rescue StandardError => e
      notify_script_generator_error(chat_id:, error: e)
    end
  end
end
