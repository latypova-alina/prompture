module MediaGenerator
  module UserMessage
    class PromptMessagePresenter < ::BasePresenter
      include MessageInterface

      def initialize(prompt_message)
        super()
        @prompt_message = prompt_message
      end

      def formatted_text
        <<~HTML
          <blockquote>#{prompt}</blockquote>

          #{I18n.t(suffix_key)}
        HTML
      end

      delegate :inline_keyboard, to: :button_builder

      private

      attr_reader :prompt_message

      delegate :prompt, :command_request, to: :prompt_message
      delegate :suffix_key, to: :suffix_builder

      def suffix_builder
        PromptMessageSuffixBuilder.new(command_request:)
      end

      def button_builder
        PromptMessageButtonBuilder.new(command_request:, locale:)
      end
    end
  end
end
