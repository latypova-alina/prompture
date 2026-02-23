module Generator
  module Prompt
    class SuccessNotifierJob < ApplicationJob
      include Memery

      def perform(extended_prompt, chat_id, button_request_id, locale)
        @extended_prompt = extended_prompt
        @button_request_id = button_request_id

        with_locale(locale) do
          TelegramIntegration::SendMessageWithButtons.call(
            chat_id:,
            reply_data:,
            request:
          )
        end

        request.update!(prompt: extended_prompt, status: "COMPLETED")
      end

      private

      delegate :reply_data, to: :presenter
      attr_reader :extended_prompt, :button_request_id

      def presenter
        ::ButtonRequestPresenters::ExtendedPromptMessagePresenter.new(message: extended_prompt)
      end

      def locale
        request.user.locale.to_s
      end

      memoize def request
        ButtonExtendPromptRequest
          .includes(command_request: :user)
          .find(button_request_id)
      end
    end
  end
end
