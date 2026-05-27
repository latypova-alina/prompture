module Generator
  module Media
    module Image
      module RetrieveTask
        class FluxImageRetriever
          def initialize(media_url:, button_request_id:, processor:)
            @source_media_url = media_url
            @button_request_id = button_request_id
            @processor = processor
          end

          def media_url
            stored_media_retriever.internal_media_url || source_media_url
          rescue StandardError
            source_media_url
          end

          private

          attr_reader :source_media_url, :button_request_id, :processor

          def stored_media_retriever
            Generator::Media::StoredMedia::Retriever.new(
              media_url: source_media_url,
              button_request_id:,
              processor:
            )
          end
        end
      end
    end
  end
end
