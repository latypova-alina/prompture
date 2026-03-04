module Generator
  module Media
    module Video
      class ErrorNotifierJob < Generator::Media::ErrorNotifierBaseJob
        private

        def error_text
          I18n.t("errors.video_generating_error")
        end

        def request_class
          ButtonVideoProcessingRequest
        end
      end
    end
  end
end
