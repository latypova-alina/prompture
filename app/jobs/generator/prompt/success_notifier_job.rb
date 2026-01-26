module Generator
  module Prompt
    class SuccessNotifierJob
      include Sidekiq::Job

      def perform(extended_prompt, chat_id, button_request_id)
        @extended_prompt = extended_prompt
        @button_request_id = button_request_id

        Telegram::SendMessageWithButtons.call(
          chat_id:,
          presenter:,
          request:
        )
      end

      private

      delegate :reply_data, to: :presenter
      attr_reader :extended_prompt, :button_request_id

      def presenter
        ::ButtonRequestPresenters::ExtendedPromptMessagePresenter.new(extended_prompt)
      end

      def request
        ButtonExtendPromptRequest.find(button_request_id)
      end
    end
  end
end
