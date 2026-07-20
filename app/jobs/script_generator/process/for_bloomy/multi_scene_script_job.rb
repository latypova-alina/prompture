module ScriptGenerator
  module Process
    module ForBloomy
      class MultiSceneScriptJob < ApplicationJob
        include JobErrorHandler

        def perform(chat_id)
          ScriptGenerator::ForBloomy::MultiSceneScript::Processor.call(chat_id:)
        rescue StandardError => e
          notify_script_generator_error(chat_id:, error: e)
        end
      end
    end
  end
end
