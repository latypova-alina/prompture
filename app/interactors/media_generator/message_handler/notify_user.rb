module MediaGenerator
  module MessageHandler
    class NotifyUser
      include Interactor

      def call
        TelegramIntegration::DeleteBotTelegramMessage.call(request: user)
        TelegramIntegration::SendMessageWithButtons.call(
          reply_data:,
          request: prompt_message
        )
      end

      private

      delegate :prompt_message, to: :context
      delegate :command_request, to: :prompt_message
      delegate :user, to: :command_request
      delegate :reply_data, to: :presenter

      def presenter
        MediaGenerator::UserMessage::PromptMessagePresenter.new(prompt_message)
      end
    end
  end
end
