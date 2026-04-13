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
          return media_url unless image_processor?

          uploader.call
          uploader.stored_url
        end

        private

        attr_reader :media_url, :button_request_id, :processor

        memoize def image_request
          ButtonImageProcessingRequest.find(button_request_id)
        end

        def image_processor?
          Generator::Processors::IMAGE.include?(processor)
        end

        memoize def uploader
          Uploader.new(media_url:, record: image_request)
        end
      end
    end
  end
end
