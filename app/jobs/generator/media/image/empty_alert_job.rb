module Generator
  module Media
    module Image
      class EmptyAlertJob < Generator::Media::EmptyAlertBaseJob
        private

        def error_text
          I18n.t("errors.empty_generation_our_fault_image")
        end

        def request_class
          ButtonImageProcessingRequest
        end
      end
    end
  end
end
