module Generator
  module Media
    module Image
      class FreepikEmptyAlertJob < Generator::Media::FreepikEmptyAlertBaseJob
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
