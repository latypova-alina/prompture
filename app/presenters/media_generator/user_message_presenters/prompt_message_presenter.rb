module MediaGenerator
  module UserMessagePresenters
    class PromptMessagePresenter < ::BasePresenter
      include MessageInterface

      def initialize(prompt_message)
        super()
        @prompt_message = prompt_message
      end

      def formatted_text
        <<~HTML
          <blockquote>#{prompt}</blockquote>

          #{I18n.t('telegram_webhooks.message.prompt_suffix')}
        HTML
      end

      def inline_keyboard
        Buttons::ForInitialPromptMessage.build(locale:)
      end

      private

      attr_reader :prompt_message

      delegate :prompt, to: :prompt_message
    end
  end
end
