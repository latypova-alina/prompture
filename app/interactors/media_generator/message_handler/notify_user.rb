module MediaGenerator
  module MessageHandler
    class NotifyUser
      include Interactor

      delegate :prompt_message, :chat_id, to: :context

      def call
        TelegramIntegration::SendMessageWithButtons.call(
          chat_id:,
          reply_data:,
          request: prompt_message
        )
      end

      private

      delegate :reply_data, to: :presenter

      def presenter
        MediaGenerator::UserMessagePresenters::PromptMessagePresenter.new(prompt_message)
      end
    end
  end
end
