module MediaGenerator
  module ButtonHandler
    class MarkAwaitingVideoPrompt
      include Interactor

      delegate :parent_request, to: :context

      def call
        return context.fail!(error: CommandUnknownError) unless image_to_video_command?

        command_request.update!(awaiting_video_prompt: true)
        context.command_request = command_request
      end

      private

      delegate :command_request, to: :parent_request

      def image_to_video_command?
        command_request.is_a?(CommandImageToVideoRequest)
      end
    end
  end
end
