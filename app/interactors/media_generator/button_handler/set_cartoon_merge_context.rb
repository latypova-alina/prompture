module MediaGenerator
  module ButtonHandler
    class SetCartoonMergeContext
      include Interactor
      include Memery

      delegate :parent_request, to: :context

      def call
        context.audio_request = audio_request
        context.button_video_processing_request = resolve_button_video_processing_request
      end

      private

      memoize def audio_request
        parent_request
      end

      def resolve_button_video_processing_request
        candidate = audio_request.parent_request

        candidate if candidate.is_a?(ButtonVideoProcessingRequest)
      end
    end
  end
end
