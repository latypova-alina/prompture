module MediaGenerator
  module UserMessage
    class PromptMessageButtonBuilder
      BUILDERS = {
        CommandPromptToAudioRequest => Buttons::ForPromptMessage::ForAudio
      }.freeze

      DEFAULT_INLINE_KEYBOARD = Buttons::ForPromptMessage::ForMedia

      def initialize(command_request:, locale:)
        @command_request = command_request
        @locale = locale
      end

      def inline_keyboard
        builder_class.build(locale:)
      end

      private

      attr_reader :command_request, :locale

      def builder_class
        BUILDERS.fetch(command_request.class, DEFAULT_INLINE_KEYBOARD)
      end
    end
  end
end
