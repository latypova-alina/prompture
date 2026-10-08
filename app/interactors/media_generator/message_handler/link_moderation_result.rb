module MediaGenerator
  module MessageHandler
    # A text prompt is moderated before its PromptMessage exists; once it's created, link them.
    class LinkModerationResult
      include Interactor

      delegate :moderation_result, :prompt_message, to: :context

      def call
        moderation_result.update!(moderatable: prompt_message)
      end
    end
  end
end
