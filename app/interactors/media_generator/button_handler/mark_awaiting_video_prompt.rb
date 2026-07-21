module MediaGenerator
  module ButtonHandler
    class MarkAwaitingVideoPrompt
      include Interactor

      delegate :parent_request, to: :context

      def call
        return context.fail!(error: CommandUnknownError) unless video_prompt_command?

        command_request.update!(awaiting_video_prompt: true)
        context.command_request = command_request
      end

      private

      delegate :command_request, to: :parent_request

      def video_prompt_command?
        command_request.is_a?(CommandImageToVideoRequest) ||
          command_request.is_a?(CommandTwoFrameToVideoRequest)
      end
    end
  end
end
