module ScriptGenerator
  module Process
    module ForCartoon
      class MultiSceneScriptJob < ApplicationJob
        include JobErrorHandler

        def perform(chat_id)
          ScriptGenerator::ForCartoon::MultiSceneScript::Processor.call(chat_id:)
        rescue StandardError => e
          notify_script_generator_error(chat_id:, error: e)
        end
      end
    end
  end
end
