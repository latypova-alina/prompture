module Generator
  module Prompt
    class BaseNotifierJob < ApplicationJob
      include WithLocaleInterface

      private

      def request_class
        ButtonExtendPromptRequest
      end
    end
  end
end
