module Generator
  module Media
    module Audio
      class ErrorNotifierJob < Generator::Media::ErrorNotifierBaseJob
        private

        def error_text
          I18n.t("errors.audio_generating_error")
        end

        def request_class
          ButtonAudioProcessingRequest
        end
      end
    end
  end
end
