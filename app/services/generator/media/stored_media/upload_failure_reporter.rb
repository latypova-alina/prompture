module Generator
  module Media
    module StoredMedia
      class UploadFailureReporter
        def self.call(...)
          new(...).call
        end

        def initialize(error:, button_request_id:, processor:, media_url:)
          @error = error
          @button_request_id = button_request_id
          @processor = processor
          @media_url = media_url
        end

        def call
          Rails.logger.error(log_message)
          Sentry.capture_exception(error, extra: { button_request_id:, processor:, media_url: })
        end

        private

        attr_reader :error, :button_request_id, :processor, :media_url

        def log_message
          "[Generator::Media::StoredMedia::UploadFailureReporter] internal upload failed for " \
            "button_request_id=#{button_request_id} processor=#{processor}: #{error.class}: #{error.message}"
        end
      end
    end
  end
end
