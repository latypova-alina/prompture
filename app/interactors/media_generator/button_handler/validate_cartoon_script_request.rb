module MediaGenerator
  module ButtonHandler
    class ValidateCartoonScriptRequest
      include Interactor

      delegate :command_request, to: :context

      def call
        return if CommandEditImageRequest.cartoon_script_edit_image?(command_request:) && script.present?

        context.fail!(error: CommandUnknownError)
      end

      private

      def script
        Script.find_by(image_prompt_id: command_request.image_prompt_id)
      end
    end
  end
end
