module MediaGenerator
  module ButtonHandler
    class ValidateCartoonScriptRequest
      include Interactor

      delegate :command_request, to: :context

      def call
        context.script = script

        return if CommandEditImageRequest.cartoon_script?(command_request) && context.script.present?

        context.fail!(error: CommandUnknownError)
      end

      private

      delegate :image_prompt_id, to: :command_request

      def script
        Script.find_by(image_prompt_id:)
      end
    end
  end
end
