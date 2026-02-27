module Generator
  module Prompt
    class SuccessNotifierJob < BaseNotifierJob
      include Memery

      def perform(extended_prompt, button_request_id)
        @extended_prompt = extended_prompt
        @button_request_id = button_request_id

        with_locale(locale) do
          TelegramIntegration::SendMessageWithButtons.call(
            reply_data:,
            request:
          )
        end

        request.update!(prompt: extended_prompt, status: "COMPLETED")
      end

      private

      attr_reader :extended_prompt, :button_request_id

      delegate :reply_data, to: :presenter

      def presenter
        MediaGenerator::ButtonRequestPresenters::ExtendedPromptMessagePresenter.new(message: extended_prompt)
      end
    end
  end
end
