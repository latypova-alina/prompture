module MediaGenerator
  module MessageHandler
    class ModerateMessage
      include Interactor

      delegate :message_text, to: :context

      def call
        context.fail!(error: ModerationError) if Moderation::OpenaiModeration.flagged?(message_text)
      end
    end
  end
end
