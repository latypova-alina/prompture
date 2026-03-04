module Generator
  module Media
    module Image
      class ErrorNotifierJob < Generator::Media::ErrorNotifierBaseJob
        private

        def error_text
          I18n.t("errors.image_generating_error")
        end

        def request_class
          ButtonImageProcessingRequest
        end
      end
    end
  end
end
