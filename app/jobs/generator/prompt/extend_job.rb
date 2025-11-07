module Generator
  module Prompt
    class ExtendJob
      include Sidekiq::Job

      def perform(raw_prompt, chat_id)
        @raw_prompt = raw_prompt
        @chat_id = chat_id

        ::Generator::Prompt::SuccessNotifierJob.perform_async(extended_prompt, chat_id)
      rescue ChatGpt::ResponseError
        ::Generator::Prompt::ErrorNotifierJob.perform_async(chat_id)
      end

      private

      delegate :extended_prompt, to: :prompt_extender

      attr_reader :raw_prompt, :chat_id

      def prompt_extender
        ::Generator::PromptExtender.new(raw_prompt)
      end
    end
  end
end
