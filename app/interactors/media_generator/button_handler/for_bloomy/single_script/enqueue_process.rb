module MediaGenerator
  module ButtonHandler
    module ForBloomy
      module SingleScript
        class EnqueueProcess
          include Interactor

          delegate :command_request, to: :context
          delegate :chat_id, :category, to: :command_request

          def call
            ScriptGenerator::Process::ForBloomy::SingleScriptJob.perform_async(chat_id, category)
          end
        end
      end
    end
  end
end
