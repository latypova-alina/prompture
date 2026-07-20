module ScriptGenerator
  module Process
    module ForBloomy
      class SingleScriptJob < ApplicationJob
        include JobErrorHandler

        def perform(chat_id, category = ContentCategory::BLOOMY_CARTOON_SCRIPT)
          ScriptGenerator::ForBloomy::SingleScript::Processor.call(chat_id:, category:)
        rescue StandardError => e
          notify_script_generator_error(chat_id:, error: e)
        end
      end
    end
  end
end
