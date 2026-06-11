module MediaGenerator
  module ButtonHandler
    class ValidateCartoonScriptRequest
      include Interactor
      include Memery

      delegate :command_request, to: :context

      def call
        context.script = script

        return if command_request.cartoon_script? && script.present?

        context.fail!(error: CommandUnknownError)
      end

      private

      delegate :image_prompt_id, to: :command_request

      memoize def script
        Script.find_by(image_prompt_id:)
      end
    end
  end
end
