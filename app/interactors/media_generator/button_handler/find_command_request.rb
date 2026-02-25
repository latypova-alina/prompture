module MediaGenerator
  module ButtonHandler
    class FindCommandRequest
      include Interactor
      include Memery

      delegate :parent_request, to: :context

      COMMAND_REQUEST_CLASSES = [
        CommandPromptToImageRequest,
        CommandPromptToVideoRequest,
        CommandImageToVideoRequest,
        CommandImageFromReferenceRequest
      ].freeze

      def call
        context.command_request = command_request
      end

      private

      memoize def command_request
        return parent_request if COMMAND_REQUEST_CLASSES.include?(parent_request.class)

        parent_request.command_request
      end
    end
  end
end
