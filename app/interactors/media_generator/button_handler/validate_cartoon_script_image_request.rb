module MediaGenerator
  module ButtonHandler
    class ValidateCartoonScriptImageRequest
      include Interactor

      delegate :command_request, to: :context

      def call
        return if command_request.cartoon_script?

        context.fail!(error: CommandUnknownError)
      end
    end
  end
end
