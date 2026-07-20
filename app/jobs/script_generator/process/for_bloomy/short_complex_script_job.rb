module ScriptGenerator
  module Process
    module ForBloomy
      class ShortComplexScriptJob < ApplicationJob
        include JobErrorHandler

        def perform(chat_id)
          ScriptGenerator::ForBloomy::ShortComplexScript::Processor.call(chat_id:)
        rescue StandardError => e
          notify_script_generator_error(chat_id:, error: e)
        end
      end
    end
  end
end
