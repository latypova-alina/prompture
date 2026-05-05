module ScriptGenerator
  class GenerateRandomScriptJob < ApplicationJob
    def perform(chat_id)
      ScriptGenerator::GenerateRandomScript.call(chat_id:)
    end
  end
end
