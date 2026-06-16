module Generator
  module Media
    module Video
      class EmptyAlertJob < Generator::Media::EmptyAlertBaseJob
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
