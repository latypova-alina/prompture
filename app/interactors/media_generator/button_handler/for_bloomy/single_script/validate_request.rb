module MediaGenerator
  module ButtonHandler
    module ForBloomy
      module SingleScript
        class ValidateRequest
          include Interactor

          delegate :command_request, to: :context

          def call
            return if command_request.cartoon_workflow?

            context.fail!(error: CommandUnknownError)
          end
        end
      end
    end
  end
end
