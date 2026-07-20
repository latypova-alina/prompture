module ScriptGenerator
  module ForCats
    class GenerateScriptJob < ApplicationJob
      include JobErrorHandler

      def perform(chat_id, template_name = nil)
        ScriptGenerator::ForCats::Processor.call(chat_id:, template_name:)
      rescue StandardError => e
        notify_script_generator_error(chat_id:, error: e)
      end
    end
  end
end
