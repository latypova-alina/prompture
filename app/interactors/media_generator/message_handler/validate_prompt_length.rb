module MediaGenerator
  module MessageHandler
    class ValidatePromptLength
      include Interactor

      MAX_LENGTH = 3500

      delegate :message_text, to: :context

      def call
        context.fail!(error: PromptTooLongError) if message_text.length > MAX_LENGTH
      end
    end
  end
end
