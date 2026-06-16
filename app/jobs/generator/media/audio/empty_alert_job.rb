module Generator
  module Media
    module Audio
      class EmptyAlertJob < Generator::Media::EmptyAlertBaseJob
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
