module MediaGenerator
  module ButtonHandler
    class ValidateCartoonScriptRequest
      include Interactor
      include Memery

      delegate :command_request, to: :context

      def call
        context.scene = scene

        return if command_request.cartoon_workflow? && scene.present?

        context.fail!(error: CommandUnknownError)
      end

      private

      delegate :image_prompt_id, to: :command_request

      memoize def scene
        Scene.find_by(image_prompt_id:)
      end
    end
  end
end
