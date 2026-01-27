module Generator
  module Prompt
    class ExtendJob
      include Sidekiq::Job

      def perform(raw_prompt, chat_id, button_request_id)
        @raw_prompt = raw_prompt

        SuccessNotifierJob.perform_async(extended_prompt, chat_id, button_request_id)
      rescue ChatGpt::ResponseError
        ErrorNotifierJob.perform_async(chat_id)
      end

      private

      delegate :extended_prompt, to: :prompt_extender

      attr_reader :raw_prompt

      def prompt_extender
        ::Generator::PromptExtender.new(raw_prompt)
      end
    end
  end
end
