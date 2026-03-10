module Generator
  module Media
    module Prompt
      class ErrorNotifierJob < Generator::Media::ErrorNotifierBaseJob
        private

        def error_text
          I18n.t("errors.extend_prompt_error")
        end

        def request_class
          ButtonExtendPromptRequest
        end
      end
    end
  end
end
