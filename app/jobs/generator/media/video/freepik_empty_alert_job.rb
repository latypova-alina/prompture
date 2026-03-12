module Generator
  module Media
    module Video
      class FreepikEmptyAlertJob < Generator::Media::FreepikEmptyAlertBaseJob
        private

        def error_text
          I18n.t("errors.empty_generation_our_fault_video")
        end

        def request_class
          ButtonVideoProcessingRequest
        end
      end
    end
  end
end
