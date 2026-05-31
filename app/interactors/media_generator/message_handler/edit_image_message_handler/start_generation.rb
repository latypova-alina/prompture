module MediaGenerator
  module MessageHandler
    module EditImageMessageHandler
      class StartGeneration
        include Interactor

        delegate :command_request, to: :context

        def call
          context.parent_request = command_request.latest_image_message
          context.button_request = "nano_banana_edit_image"

          create_result = MediaGenerator::ButtonHandler::CreateRequest.call(context)
          return context.fail!(error: create_result.error) if create_result.failure?

          balance_result = MediaGenerator::ButtonHandler::DecrementBalance.call(context)
          return context.fail!(error: balance_result.error) if balance_result.failure?

          MediaGenerator::ButtonHandler::SendGenerationTask.call(context)
        end
      end
    end
  end
end
