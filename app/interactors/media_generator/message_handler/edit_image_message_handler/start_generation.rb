module MediaGenerator
  module MessageHandler
    module EditImageMessageHandler
      class StartGeneration
        include Interactor

        PROCESSOR = "nano_banana_edit_image".freeze

        delegate :command_request, to: :context

        def call
          prepare_context

          return context.fail!(error: create_result.error) if create_result.failure?
          return context.fail!(error: balance_result.error) if balance_result.failure?

          send_generation_task
        end

        private

        def prepare_context
          context.parent_request = command_request.latest_image_message
          context.button_request = PROCESSOR
        end

        def create_result
          MediaGenerator::ButtonHandler::CreateRequest.call(context)
        end

        def balance_result
          MediaGenerator::ButtonHandler::DecrementBalance.call(context)
        end

        def send_generation_task
          MediaGenerator::ButtonHandler::SendGenerationTask.call(context)
        end
      end
    end
  end
end
