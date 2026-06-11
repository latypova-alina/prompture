module MediaGenerator
  module ButtonHandler
    class ValidateCartoonVideoScriptRequest
      include Interactor
      include Memery

      delegate :command_request, :parent_request, to: :context

      def call
        context.script = script
        context.video_prompt = video_prompt

        return if command_request.cartoon_script? && script.present?

        context.fail!(error: CommandUnknownError)
      end

      private

      memoize def video_prompt
        prompt_message.video_prompt
      end

      memoize def script
        video_prompt&.script
      end

      memoize def prompt_message
        parent_request.prompt_message
      end
    end
  end
end
