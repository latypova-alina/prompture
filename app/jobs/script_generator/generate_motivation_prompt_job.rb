module ScriptGenerator
  class GenerateMotivationPromptJob < ApplicationJob
    include JobErrorHandler

    def perform(chat_id)
      ScriptGenerator::ProcessMotivationPrompts.call(chat_id:)
    rescue StandardError => e
      notify_script_generator_error(chat_id:, error: e)
    end
  end
end
