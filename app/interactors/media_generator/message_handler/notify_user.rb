module MediaGenerator
  module MessageHandler
    class NotifyUser
      include Interactor

      delegate :prompt_message, to: :context

      def call
        TelegramIntegration::DeleteAdminProcessingMessage.call(user: prompt_message.command_request.user)
        TelegramIntegration::SendMessageWithButtons.call(
          reply_data:,
          request: prompt_message
        )
      end

      private

      delegate :reply_data, to: :presenter

      def presenter
        MediaGenerator::UserMessage::PromptMessagePresenter.new(prompt_message)
      end
    end
  end
end
