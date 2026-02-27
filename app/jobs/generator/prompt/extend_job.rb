module Generator
  module Prompt
    class ExtendJob < ApplicationJob
      include Memery

      def perform(button_request_id)
        @button_request_id = button_request_id

        SuccessNotifierJob.perform_async(extended_prompt, button_request_id)
      rescue ChatGpt::ResponseError
        ErrorNotifierJob.perform_async(button_request_id)
      end

      private

      delegate :extended_prompt, to: :prompt_extender
      delegate :parent_request, to: :button_request

      attr_reader :button_request_id

      def prompt_extender
        ::Generator::PromptExtender.new(raw_prompt)
      end

      memoize def button_request
        ButtonExtendPromptRequest.find(button_request_id)
      end

      def raw_prompt
        parent_request.parent_prompt
      end
    end
  end
end
