module Generator
  module Media
    module StoredMedia
      class Retriever
        include Memery

        def initialize(media_url:, button_request_id:, processor:)
          @media_url = media_url
          @button_request_id = button_request_id
          @processor = processor
        end

        def internal_media_url
          return media_url unless stored_media_type.needs_to_be_stored?

          uploader.call
          uploader.stored_url
        end

        private

        attr_reader :media_url, :button_request_id, :processor

        delegate :uploader, to: :stored_media_type, private: true

        memoize def stored_media_type
          StoredMediaType.new(processor:, media_url:, button_request_id:)
        end
      end
    end
  end
end
