module Generator
  module Media
    module Prompt
      class FreepikEmptyAlertJob < Generator::Media::FreepikEmptyAlertBaseJob
        private

        def error_text
          I18n.t("errors.empty_generation_our_fault_prompt")
        end

        def request_class
          ButtonExtendPromptRequest
        end
      end
    end
  end
end
