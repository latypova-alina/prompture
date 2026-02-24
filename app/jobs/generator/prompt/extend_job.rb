module Generator
  module Prompt
    class ExtendJob < ApplicationJob
      include WithLocaleInterface

      def perform(raw_prompt, chat_id, button_request_id)
        @raw_prompt = raw_prompt
        @button_request_id = button_request_id

        SuccessNotifierJob.perform_async(extended_prompt, chat_id, button_request_id, locale)
      rescue ChatGpt::ResponseError
        ErrorNotifierJob.perform_async(chat_id, locale)
      end

      private

      delegate :extended_prompt, to: :prompt_extender

      attr_reader :raw_prompt, :button_request_id

      def prompt_extender
        ::Generator::PromptExtender.new(raw_prompt)
      end

      def request_class
        ButtonExtendPromptRequest
      end
    end
  end
end
