module Generator
  module Media
    module Image
      class CancellationNotifierJob < Generator::Media::CancellationNotifierBaseJob
        private

        def message_text
          I18n.t("errors.generation_cancelled_successfully", processor_name: humanized_process_name)
        end

        def request_class
          ButtonImageProcessingRequest
        end
      end
    end
  end
end
