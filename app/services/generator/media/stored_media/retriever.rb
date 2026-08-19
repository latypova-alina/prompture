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
        rescue StandardError => e
          report_upload_failure(e)
          media_url
        end

        private

        attr_reader :media_url, :button_request_id, :processor

        def report_upload_failure(error)
          Rails.logger.error(
            "[Generator::Media::StoredMedia::Retriever] internal upload failed for " \
            "button_request_id=#{button_request_id} processor=#{processor}: #{error.class}: #{error.message}"
          )
          Sentry.capture_exception(error, extra: { button_request_id:, processor:, media_url: })
        end

        memoize def uploader
          stored_media_type.uploader
        end

        memoize def stored_media_type
          StoredMediaType.new(processor:, media_url:, button_request_id:)
        end
      end
    end
  end
end
