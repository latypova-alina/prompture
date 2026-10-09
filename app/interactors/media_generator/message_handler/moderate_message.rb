module MediaGenerator
  module MessageHandler
    class ModerateMessage
      include Interactor
      include Memery

      delegate :message_text, :command_request, to: :context
      delegate :blocked?, to: :moderation_result

      def call
        context.moderation_result = moderation_result
        context.fail!(error: ModerationError) if blocked?
      end

      private

      memoize def moderation_result
        Moderation::RecordedCheck.call(moderation: Moderation::OpenaiModeration.new(message_text), input:)
      end

      def input
        Moderation::Input.new(input_kind: "text", input_text: message_text, command_request:)
      end
    end
  end
end
