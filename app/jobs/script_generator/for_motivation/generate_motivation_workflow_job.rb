module ScriptGenerator
  module ForMotivation
    class GenerateMotivationWorkflowJob < ApplicationJob
      include JobErrorHandler

      def perform(chat_id, language = "en")
        ProcessMotivationWorkflow.call(chat_id:, language:)
      rescue StandardError => e
        notify_script_generator_error(chat_id:, error: e)
      end
    end
  end
end
