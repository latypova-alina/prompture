module Generator
  module Media
    module Audio
      class FalTaskRetrieverJob < ApplicationJob
        def perform(generated_media_url, button_request_id, processor)
          @generated_media_url = generated_media_url
          @button_request_id = button_request_id
          @processor = processor

          SuccessNotifierJob.perform_async(media_url, button_request_id)
        rescue Generator::ResponseError
          ErrorNotifierJob.perform_async(button_request_id)
        end

        private

        attr_reader :generated_media_url, :button_request_id, :processor

        def media_url
          stored_media.internal_media_url || generated_media_url
        rescue StandardError
          generated_media_url
        end

        def stored_media
          Generator::Media::StoredMedia::Retriever.new(
            media_url: generated_media_url,
            button_request_id:,
            processor:
          )
        end
      end
    end
  end
end
