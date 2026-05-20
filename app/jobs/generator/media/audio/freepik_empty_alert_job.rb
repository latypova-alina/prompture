module Generator
  module Media
    module Audio
      class FreepikEmptyAlertJob < Generator::Media::FreepikEmptyAlertBaseJob
        private

        def error_text
          I18n.t("errors.empty_generation_our_fault_audio")
        end

        def request_class
          ButtonAudioProcessingRequest
        end
      end
    end
  end
end
