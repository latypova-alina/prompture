module Generator
  module Prompt
    class SuccessNotifierJob
      include Sidekiq::Job

      def perform(extended_prompt, chat_id)
        @extended_prompt = extended_prompt

        Telegram.bot.send_message(chat_id:, **reply_data)
      end

      private

      delegate :reply_data, to: :presenter
      attr_reader :extended_prompt

      def presenter
        MessagePresenter.new(extended_prompt, "prompt_message")
      end
    end
  end
end
