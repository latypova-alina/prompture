module Generator
  module Media
    module Image
      class TaskRetrieverJob < ApplicationJob
        def perform(generated_media_url, button_request_id, processor)
          @generated_media_url = generated_media_url
          @button_request_id = button_request_id
          @processor = processor

          SuccessNotifierJob.perform_async(final_media_url, button_request_id)
        rescue Freepik::ResponseError
          ErrorNotifierJob.perform_async(button_request_id)
        end

        private

        attr_reader :generated_media_url, :button_request_id, :processor

        delegate :media_url, to: :image_retriever, prefix: :final

        def image_retriever
          RetrieveTask::FluxImageRetriever.new(
            media_url: generated_media_url,
            button_request_id:,
            processor:
          )
        end
      end
    end
  end
end
