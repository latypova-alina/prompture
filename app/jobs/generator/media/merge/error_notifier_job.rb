module Generator
  module Media
    module Merge
      class ErrorNotifierJob < Generator::Media::ErrorNotifierBaseJob
        private

        def error_text
          I18n.t("errors.merge_audio_video_error")
        end

        def request_class
          ButtonMergeAudioVideoProcessingRequest
        end
      end
    end
  end
end
