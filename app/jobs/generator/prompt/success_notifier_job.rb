module Generator
  module Prompt
    class SuccessNotifierJob
      include Sidekiq::Job
      include Memery

      def perform(extended_prompt, chat_id, button_request_id)
        @extended_prompt = extended_prompt
        @button_request_id = button_request_id

        Telegram::SendMessageWithButtons.call(
          chat_id:,
          reply_data:,
          request:
        )

        request.update!(prompt: extended_prompt, status: "COMPLETED")
      end

      private

      delegate :reply_data, to: :presenter
      attr_reader :extended_prompt, :button_request_id

      def presenter
        ::ButtonRequestPresenters::ExtendedPromptMessagePresenter.new(message: extended_prompt)
      end

      memoize def request
        ButtonExtendPromptRequest.find(button_request_id)
      end
    end
  end
end
