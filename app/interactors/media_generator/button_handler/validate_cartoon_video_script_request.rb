module MediaGenerator
  module ButtonHandler
    class ValidateCartoonVideoScriptRequest
      include Interactor
      include Memery

      delegate :command_request, :parent_request, to: :context

      # parent_request is a ButtonVideoProcessingRequest
      # the request tied to the message the button was pressed on
      delegate :prompt_message, to: :parent_request
      delegate :video_prompt, to: :prompt_message
      delegate :script, to: :video_prompt

      memoize :prompt_message, :video_prompt, :script

      private :prompt_message, :video_prompt, :script

      def call
        context.script = script
        context.video_prompt = video_prompt

        return if command_request.cartoon_script? && script.present?

        context.fail!(error: CommandUnknownError)
      end
    end
  end
end
